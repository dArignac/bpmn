<script lang="ts">
  import { open, save } from "@tauri-apps/api/dialog";
  import {
    readTextFile,
    writeBinaryFile,
    writeTextFile,
  } from "@tauri-apps/api/fs";
  import "bpmn-js/dist/assets/bpmn-font/css/bpmn.css";
  import "bpmn-js/dist/assets/diagram-js.css";
  import BpmnModeler from "bpmn-js/lib/Modeler";
  import { Canvg, presets } from "canvg";
  import { onDestroy, onMount } from "svelte";

  let container;
  let modeler;
  let canvas;

  onMount(async () => {
    modeler = new BpmnModeler({
      container: container,
      // FIXME check keyboard bindings
      // keyboard: { bindInfo: document }
    });
    modeler.createDiagram();
  });

  onDestroy(() => {
    modeler.destroy();
  });

  // FIXME should be shown in app title
  let loadedFilePath = "";

  async function saveBPMNFile(filePath: string) {
    try {
      const { xml } = await modeler.saveXML({ format: true });
      await writeTextFile(filePath, xml);
      // FIXME success dialog
    } catch (err) {
      // FIXME error handling
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
        loadedFilePath = filePath;
      }
    } catch (err) {
      // FIXME error handling
      console.error(err);
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
      // FIXME error handling
      console.error(err);
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
        loadedFilePath = filePath as string;
      }
    } catch (err) {
      // FIXME error handling
      console.log(err);
    }
  }

  async function newDiagram() {
    modeler.createDiagram();
    loadedFilePath = "";
  }
</script>

<main class="main">
  <div class="toolbar">
    <button on:click|stopPropagation|preventDefault={loadBPMN}>Load</button>
    <button on:click|stopPropagation|preventDefault={saveBPMN}>Save</button>
    <button on:click|stopPropagation|preventDefault={saveAsBPMN}>SaveAs</button>
    <button on:click|stopPropagation|preventDefault={savePNG}>PNG</button>
    <button on:click|stopPropagation|preventDefault={newDiagram}>New</button>
  </div>
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
    height: 25px;
    margin: 0 2px 0 0;
    width: 60px;
  }
  .modeler {
    height: 100vh;
    min-height: 100vh;
  }
</style>
