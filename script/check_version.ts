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

	const version1 = content.match(/^# <.+>: (.+) \(\d\d\d\d-\d\d-\d\d\)/m)![1]
	const version2 = content.match(/VERSION \?= (.+)/)![1]

	if (version1 !== version2) {
		console.error(`Version mismatch in ${filename}: ${version1} != ${version2}`)

		return false
	}

	return true
}
