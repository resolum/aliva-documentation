#!/usr/bin/env node
/**
 * Generates the Version Log from the git history and APPENDS new rows
 * (does not regenerate everything) into docs/00-cover.md, between the markers:
 *   <!-- VERSION_TABLE_START -->
 *   <!-- VERSION_TABLE_END -->
 *
 * Uses docs/scripts/version-state.json to track the version number:
 *   { "major": 1, "minor": 10, "lastCommit": "<hash or null>" }
 *
 * - "minor" is incremented automatically for each new relevant commit.
 * - "major" is changed manually when a sprint ends (optionally reset
 *   "minor" to 0 so it starts again at X.01).
 */

const { execFileSync } = require("child_process");
const fs = require("fs");
const path = require("path");

// The script lives in docs/scripts/, so the repo root is two levels up.
const REPO_ROOT = path.resolve(__dirname, "..", "..");
const DOCS_PATH = path.join(REPO_ROOT, "docs");
const COVER_FILE = path.join(REPO_ROOT, "docs", "00-cover.md");
const STATE_FILE = path.join(__dirname, "version-state.json");

const START_MARK = "<!-- VERSION_TABLE_START -->";
const END_MARK = "<!-- VERSION_TABLE_END -->";

// Conventional commit prefixes we want to log as a version.
const VALID_PREFIXES = ["feat", "fix", "docs", "refactor", "chore", "style", "test"];

const COMMIT_SEP = "@@COMMIT@@";
const FIELD_SEP = "@@FIELD@@";

function loadState() {
    if (!fs.existsSync(STATE_FILE)) {
        return { major: 1, minor: 0, lastCommit: null };
    }
    return JSON.parse(fs.readFileSync(STATE_FILE, "utf-8"));
}

function saveState(state) {
    fs.writeFileSync(STATE_FILE, JSON.stringify(state, null, 2) + "\n", "utf-8");
}

function getNewCommits(lastCommit) {
    const fmt = `${COMMIT_SEP}%H${FIELD_SEP}%an${FIELD_SEP}%ad${FIELD_SEP}%s`;
    const range = lastCommit ? `${lastCommit}..HEAD` : "HEAD";
    const raw = execFileSync(
        "git",
        [
            "log",
            "--reverse",
            range,
            `--pretty=format:${fmt}`,
            "--date=format:%d/%m/%y",
            "--",
            DOCS_PATH,
        ],
        { encoding: "utf-8" }
    ).trim();

    if (!raw) return [];

    return raw
        .split(COMMIT_SEP)
        .map((chunk) => chunk.trim())
        .filter(Boolean)
        .map((chunk) => {
            const [hash, author, date, subject] = chunk.split(FIELD_SEP);
            return { hash, author, date, subject };
        });
}

function cleanDescription(subject) {
    const match = subject.match(/^(\w+)(\([^)]*\))?:\s*(.+)$/);
    let desc = match ? match[3] : subject;
    desc = desc.trim();
    if (desc) {
        desc = desc[0].toUpperCase() + desc.slice(1);
    }
    return desc;
}

function isRelevant(subject) {
    const prefix = subject.split(":")[0].split("(")[0].trim().toLowerCase();
    return VALID_PREFIXES.includes(prefix);
}

function escapeHtml(str) {
    return str
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;");
}

function formatVersion(major, minor) {
    return `${major}.${String(minor).padStart(2, "0")}`;
}

function buildRows(commits, state) {
    const rows = [];
    for (const c of commits) {
        if (!isRelevant(c.subject)) continue;
        state.minor += 1;
        const version = formatVersion(state.major, state.minor);
        const desc = escapeHtml(cleanDescription(c.subject));
        const author = escapeHtml(c.author);
        rows.push(
            [
                "    <tr>",
                `        <td> ${version} </td>`,
                `        <td> ${c.date} </td>`,
                `        <td> ${author} </td>`,
                `        <td> ${desc} </td>`,
                "    </tr>",
            ].join("\n")
        );
    }
    return rows;
}

const TABLE_SKELETON = [
    "<table>",
    "    <tr>",
    "        <th> Versión </th>",
    "        <th> Fecha </th>",
    "        <th> Autor </th>",
    "        <th> Descripción de la modificación </th>",
    "    </tr>",
    "</table>",
].join("\n");

/**
 * Updates ONLY the block between START_MARK and END_MARK, never touching
 * the rest of the file (important if the document has other <table> tags
 * elsewhere, e.g. in other sections before the cover page).
 */
function updateMarkedBlock(content, newRows) {
    const startIdx = content.indexOf(START_MARK);
    const endIdx = content.indexOf(END_MARK);

    if (startIdx === -1 || endIdx === -1 || endIdx < startIdx) {
        throw new Error(`Markers ${START_MARK} / ${END_MARK} not found in ${COVER_FILE}`);
    }

    const before = content.slice(0, startIdx + START_MARK.length);
    const after = content.slice(endIdx);
    let block = content.slice(startIdx + START_MARK.length, endIdx);

    // If there is no table yet inside the marked block, start from the skeleton.
    if (!block.includes("<table>")) {
        block = `\n${TABLE_SKELETON}\n`;
    }

    if (newRows.length > 0) {
        const rowsBlock = newRows.join("\n");
        // Insert new rows right before the closing </table> that belongs to
        // THIS block (not the first </table> in the whole document).
        const lastTableCloseIdx = block.lastIndexOf("</table>");
        block =
            block.slice(0, lastTableCloseIdx) +
            `${rowsBlock}\n` +
            block.slice(lastTableCloseIdx);
    }

    return before + block + after;
}

function main() {
    const state = loadState();

    if (!fs.existsSync(COVER_FILE)) {
        throw new Error(`File not found: ${COVER_FILE}`);
    }

    const content = fs.readFileSync(COVER_FILE, "utf-8");
    if (!content.includes(START_MARK) || !content.includes(END_MARK)) {
        throw new Error(
            `Markers ${START_MARK} / ${END_MARK} not found in ${COVER_FILE}`
        );
    }

    const commits = getNewCommits(state.lastCommit);
    if (commits.length === 0) {
        console.log("No new commits under docs/. Nothing to update.");
        return;
    }

    const newRows = buildRows(commits, state);
    const newContent = updateMarkedBlock(content, newRows);

    fs.writeFileSync(COVER_FILE, newContent, "utf-8");

    state.lastCommit = commits[commits.length - 1].hash;
    saveState(state);

    console.log(`Added ${newRows.length} new row(s). Current version: ${formatVersion(state.major, state.minor)}`);
}

main();