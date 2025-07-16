<script setup lang="ts">
const isDev = !window.hphone;
</script>

<template>
  <div class="dev" v-if="isDev">
    <div class="frame">
      <img src="/frame.png">
      <div class="content">
        <slot/>
      </div>
    </div>
  </div>

  <slot v-else/>
</template>

<style scoped>
  .dev {
    display: flex;
    justify-items: center;

    position: absolute;
    inset: 0;
  }

  .dev > .frame {
    position: relative;
    margin: 0 auto;
    height: 100%;

    --header-height: 2.4vw;
  }

  .dev > .frame > img {
    position: relative;
    width: 100%;
    height: 100%;

    z-index: 2;
    user-select: none;
    -webkit-user-select: none;
    -webkit-user-drag: none;
    pointer-events: none;
  }

  .dev > .frame > .content {
    position: absolute;
    inset: 1.2vw;
    border-radius: 3vw;

    overflow: hidden;
    z-index: 1;
  }
</style>
