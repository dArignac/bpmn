<script lang="ts">
  import { open, save } from "@tauri-apps/api/dialog";
  import {
    readTextFile,
    writeBinaryFile,
    writeTextFile,
  } from "@tauri-apps/api/fs";
  import { appWindow } from "@tauri-apps/api/window";
  import "bpmn-js/dist/assets/bpmn-font/css/bpmn.css";
  import "bpmn-js/dist/assets/diagram-js.css";
  import BpmnModeler from "bpmn-js/lib/Modeler";
  import { Canvg, presets } from "canvg";
  import { onDestroy, onMount } from "svelte";
  import Error from "./lib/Error.svelte";
  import { errorMessage } from "./store";
  import iconFolderOpen from "./assets/folder_open.svg";
  import iconSave from "./assets/save.svg";
  import iconSaveAs from "./assets/save_as.svg";
  import iconNew from "./assets/restart_alt.svg";
  import iconPNG from "./assets/image.svg";

  const appTitle = "BPMN Modeler";
  let container;
  let modeler;
  let canvas;

  onMount(async () => {
    modeler = new BpmnModeler({
      container: container,
      // @ts-ignore
      keyboard: { bindTo: document },
    });
    modeler.createDiagram();
  });

  onDestroy(() => {
    modeler.destroy();
  });

  let loadedFilePath = "";

  async function setLoadedFilePath(filePath: string) {
    loadedFilePath = filePath;
    let title = appTitle;
    if (filePath.length > 0) {
      await appWindow.setTitle(`${appTitle} - ${filePath}`);
    } else {
      await appWindow.setTitle(title);
    }
  }

  async function saveBPMNFile(filePath: string) {
    try {
      const { xml } = await modeler.saveXML({ format: true });
      await writeTextFile(filePath, xml);
    } catch (err) {
      console.log(err);
      errorMessage.update((m) => err);
    }
  }

  async function saveBPMN() {
    if (loadedFilePath.length > 0) {
      saveBPMNFile(loadedFilePath);
    } else {
      saveAsBPMN();
    }
  }

  async function saveAsBPMN() {
    try {
      const filePath = await save({
        filters: [{ name: "BPMN", extensions: ["bpmn"] }],
      });
      if (filePath !== null) {
        saveBPMNFile(filePath);
        await setLoadedFilePath(filePath);
      }
    } catch (err) {
      console.log(err);
      errorMessage.update((m) => err);
    }
  }

  async function savePNG() {
    try {
      const filePath = await save({
        filters: [{ name: "PNG", extensions: ["png"] }],
      });
      if (filePath !== null) {
        const { svg } = await modeler.saveSVG();

        const ctx = canvas.getContext("2d");
        const v = await Canvg.from(ctx, svg, presets.offscreen());
        await v.render();

        canvas.toBlob(async (blob) => {
          const content = await blob.arrayBuffer();
          await writeBinaryFile(filePath, content);
        });
      }
    } catch (err) {
      console.log(err);
      errorMessage.update((m) => err);
    }
  }

  async function loadBPMN() {
    try {
      const filePath = await open({
        multiple: false,
        filters: [
          {
            name: "Model",
            extensions: ["bpmn", "xml"],
          },
        ],
      });
      if (filePath !== null) {
        const fileContent = await readTextFile(filePath as string);
        await modeler.importXML(fileContent);
        await setLoadedFilePath(filePath as string);
      }
    } catch (err) {
      console.log(err);
      errorMessage.update((m) => err);
    }
  }

  async function newDiagram() {
    modeler.createDiagram();
    await setLoadedFilePath("");
  }
</script>

<main>
  <div class="toolbar">
    <button
      on:click|stopPropagation|preventDefault={loadBPMN}
      title="Open BPMN file"
      ><img src={iconFolderOpen} alt="Open file" /></button
    >
    <button on:click|stopPropagation|preventDefault={saveBPMN} title="Save file"
      ><img src={iconSave} alt="Save file" /></button
    >
    <button
      on:click|stopPropagation|preventDefault={saveAsBPMN}
      title="Save file as"><img src={iconSaveAs} alt="Save file as" /></button
    >
    <button on:click|stopPropagation|preventDefault={savePNG} title="Save PNG"
      ><img src={iconPNG} alt="Save PNG" /></button
    >
    <button
      on:click|stopPropagation|preventDefault={newDiagram}
      title="New diagram"><img src={iconNew} alt="New diagram" /></button
    >
  </div>
  <Error />
  <div class="modeler" bind:this={container} />
</main>
<canvas bind:this={canvas} />

<style>
  .toolbar {
    display: flex;
    flex-direction: column;
    position: absolute;
    right: 2px;
    top: 2px;
    z-index: 1000;
  }
  .toolbar button {
    background: #fff;
    border: 1px solid #ccc;
    cursor: pointer;
    height: 30px;
    margin: 0 2px 2px 0;
    padding: 1px;
    width: 30px;
  }
  .toolbar button img {
    height: 100%;
    width: 100%;
  }
  .modeler {
    height: 100vh;
    min-height: 100vh;
  }
  canvas {
    height: 0;
    width: 0;
  }
</style>
