#!/usr/bin/env -S deno run --allow-read

const main = async (args: string[]) => {
	if (args.length < 1) {
		console.error('Usage: deno run --allow-read check_version.ts [FILENAME...]')

		Deno.exit(1)
	}

	const filenames = args

	let success = true
	for (const filename of filenames) {
		const ok = await checkVersion(filename)
		success &&= ok
	}

	if (!success) {
		Deno.exit(1)
	}
}

await main(Deno.args)

async function checkVersion(filename: string): Promise<boolean> {
	const content = await Deno.readTextFile(filename)

	const v1s = [...content.matchAll(/^# <.+>: (.+) \(\d\d\d\d-\d\d-\d\d\)/gm)!].map(match => match[1])
	const v2s = [...content.matchAll(/^VERSION(?:_\w+)? \?= (.+)/gm)!].map(match => match[1])

	const checkVersionMismatch = (v1: string, v2: string): boolean => {
		if (v1 !== v2) {
			console.error(`Version mismatch: ${filename}: ${v1} != ${v2}`)

			return false
		}

		return true
	}

	return v1s
		.map((v1, i) => checkVersionMismatch(v1, v2s[i]))
		.every(Boolean)
}
