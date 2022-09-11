import { context, getOctokit } from "@actions/github";
import * as fs from "fs";
import { globby } from "globby";
import * as path from "path";

async function updateRelease(token, os) {
  const options = { owner: context.repo.owner, repo: context.repo.repo };
  const github = getOctokit(token);

  const { data: tags } = await github.rest.repos.listTags({
    ...options,
    per_page: 10,
    page: 1,
  });

  const tag = tags.find((t) => t.name.startsWith("v"));
  console.log(`Handling release ${tag.name}`);

  const { data: release } = await github.rest.repos.getReleaseByTag({
    ...options,
    tag: tag.name,
  });

  async function uploadAsset(releaseId, name, data) {
    await github.rest.repos.uploadReleaseAsset({
      ...options,
      release_id: releaseId,
      name,
      data,
    });
  }

  // differentiate in which os we are to select the correct path
  let assets = [];
  if (os === "ubuntu-latest") {
    assets = [
      "src-tauri/target/release/bundle/appimage/*_amd64.AppImage",
      "src-tauri/target/release/bundle/deb/*_amd64.deb",
    ];
  } else if (os === "macos-latest") {
    assets = [
      "src-tauri/target/release/bundle/macos/*.app",
      "src-tauri/target/release/bundle/dmg/*_x64.dmg",
    ];
  } else if (os === "windows-latest") {
    assets = ["src-tauri/target/release/bundle/msi/*.msi"];
  }

  const files = await globby(assets);
  if (files.length > 0) {
    for (const artifact of files) {
      console.log(`uploading file ${artifact}`);
      await uploadAsset(
        release.id,
        path.basename(artifact),
        fs.readFileSync(artifact)
      );
    }
  } else {
    console.log("no files for asset pattern were found. pattern: ", assets);
  }
}

await updateRelease(process.argv.slice(2)[0], process.argv.slice(3)[0]);
