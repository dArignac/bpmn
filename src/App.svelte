<script lang="ts">
  import "bpmn-js/dist/assets/bpmn-font/css/bpmn.css";
  import "bpmn-js/dist/assets/diagram-js.css";
  import BpmnModeler from "bpmn-js/lib/Modeler";
  import { onDestroy, onMount } from "svelte";
  import { open, save } from "@tauri-apps/api/dialog";
  import { readTextFile, writeTextFile } from "@tauri-apps/api/fs";

  let container;
  let modeler;

  onMount(async () => {
    modeler = new BpmnModeler({
      container: container,
      // keyboard: { bindInfo: document }
    });
    modeler.createDiagram();
  });

  onDestroy(() => {
    modeler.destroy();
  });

  async function saveBPMN() {
    try {
      const { xml } = await modeler.saveXML({ format: true });
      const filePath = await save({
        filters: [{ name: "BPMN", extensions: ["bmpn"] }],
      });
      if (filePath !== null) {
        await writeTextFile(filePath, xml);
        // FIXME success dialog
      }
    } catch (err) {
      // FIXME error handling
      console.error(err);
    }
  }

  async function savePNG() {
    try {
      const { svg } = await modeler.saveSVG();
      // FIXME save to file
      // FIXME handle PNG conversion
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
            name: "WHatIsIt",
            extensions: ["bpmn", "xml"],
          },
        ],
      });
      if (filePath !== null) {
        const fileContent = await readTextFile(filePath as string);
        await modeler.importXML(fileContent);
      }
    } catch (err) {
      // FIXME error handling
      console.log(err);
    }
  }
</script>

<main class="main">
  <div class="toolbar">
    <button on:click|stopPropagation|preventDefault={savePNG}>PNG</button>
    <button on:click|stopPropagation|preventDefault={saveBPMN}>Save</button>
    <button on:click|stopPropagation|preventDefault={loadBPMN}>Load</button>
  </div>
  <div class="modeler" bind:this={container} />
</main>

<style>
  .toolbar {
    background-color: aquamarine;
    display: flex;
    flex-direction: row-reverse;
    position: absolute;
    right: 5px;
    top: 5px;
    z-index: 1000;
  }
  .toolbar button {
    height: 25px;
    margin: 0 2px 0 0;
    width: 50px;
  }
  .modeler {
    height: 100vh;
    min-height: 100vh;
  }
</style>
