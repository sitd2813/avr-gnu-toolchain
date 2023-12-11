#!/usr/bin/env -S deno run --allow-read --allow-write --allow-sys

import * as PRETTIER from "prettier"

interface Info {
	version: string
	date: string
}

const main = async (args: string[]) => {
	if (args.length !== 1) {
		console.error(`Usage: deno run --allow-read --allow-write --allow-sys create_release_note.ts <VERSION>`)
		Deno.exit(1)
	}

	const version = args[0]

	const infoBinutils = await parseInfo(`Makefile.avr-binutils`)
	const infoGCC = await parseInfo(`Makefile.avr-gcc`)
	const infoGDB = await parseInfo(`Makefile.avr-gdb`)
	const infoLibC = await parseInfo(`Makefile.avr-libc`)

	const releaseNote = await makeReleaseNote(version, infoBinutils, infoGCC, infoGDB, infoLibC,
		`AVR GNU Toolchain ${version}`
	)
	await Deno.writeTextFile(`build/AVR-GNU-Toolchain/README.md`, releaseNote)

	const releaseNoteAMD64Windows = await makeReleaseNote(version, infoBinutils, infoGCC, infoGDB, infoLibC,
		`AVR GNU Toolchain ${version} for 64-bit Windows`,
		{ endOfLine: `crlf` }
	)
	await Deno.writeTextFile(`build/AVR-GNU-Toolchain-AMD64-Windows/README.md`, releaseNoteAMD64Windows)

	const releaseNoteGitHub = await makeReleaseNote(version, infoBinutils, infoGCC, infoGDB, infoLibC)
	await Deno.writeTextFile(`build/README.md`, releaseNoteGitHub)
}

await main(Deno.args)

async function parseInfo(filename: string): Promise<Info> {
	const content = await Deno.readTextFile(filename)
	const match = content.match(/^# <.+>: (.+) \((\d\d\d\d-\d\d-\d\d)\)/m)!
	const version = match[1]
	const date = match[2]

	return { version, date }
}

async function makeReleaseNote(version: string, infoBinutils: Info, infoGCC: Info, infoGDB: Info, infoLibC: Info, title?: string, configPrettier?: PRETTIER.Options): Promise<string> {
	let releaseNote = ``
	if (title !== undefined) {
		releaseNote += `# ${title}\n\n`
		releaseNote += `<https://github.com/sitd2813/avr-gnu-toolchain/releases/tag/v${version}>\n\n`
	}
	releaseNote += `| Tool | Version | Date |\n`
	releaseNote += `| :-: | :-: | :-: |\n`
	releaseNote += `| AVR GNU Binutils | ${infoBinutils.version} | ${infoBinutils.date} |\n`
	releaseNote += `| AVR GCC | ${infoGCC.version} | ${infoGCC.date} |\n`
	releaseNote += `| AVR GDB | ${infoGDB.version} | ${infoGDB.date} |\n`
	releaseNote += `| AVR LibC | ${infoLibC.version} | ${infoLibC.date} |\n`
	releaseNote = await PRETTIER.format(releaseNote, { ...{ parser: `markdown` }, ...configPrettier })

	return releaseNote
}
