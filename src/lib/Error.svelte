<script lang="ts">
  import { errorMessage } from "../store";

  function dismiss() {
    errorMessage.update((m) => "");
  }
</script>

<div class="error" class:show={$errorMessage.length > 0}>
  <div class="handle"><button on:click={dismiss}>Dismiss</button></div>
  <div class="message">{$errorMessage}</div>
</div>

<style>
  .error {
    align-items: start;
    background: orangered;
    bottom: 2px;
    display: none;
    gap: 2px 2px;
    grid-template-columns: 1fr;
    grid-template-rows: 1fr 1fr;
    justify-content: start;
    justify-items: end;
    padding: 2px 4px;
    position: absolute;
    right: 2px;
    z-index: 1000;
  }

  .show {
    display: grid;
  }
</style>
