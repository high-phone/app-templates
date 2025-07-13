<script setup lang="ts">
import { ref, shallowRef, watch } from 'vue';
import { AttachmentType, type Attachment } from './types';

import PhoneFrame from './PhoneFrame.vue';

const { useApplication, events, getSettings, emitNui, openModal, openModalSheet } = window.hphone || {};

const darkMode = ref(false);

if(useApplication) {
  const { options } = useApplication();

  darkMode.value = getSettings().darkMode;

  watch(darkMode, (newValue) => {
    options.darkHomebar = !newValue;
    options.darkStatusbar = !newValue;
  }, { immediate: true })

  events.on('general.SETTING_UPDATED', (data: { name: string, value: any, oldValue: any }) => {
    const { name, value, oldValue } = data;
    console.log(`Setting '${name}' has changed from '${oldValue}' to '${value}'!`)

    if(data.name === 'darkMode') {
      darkMode.value = data.value;
    }
  })

  events.on('general.CHANGED_STATE', (state: 'off' | 'screen_off' | 'locked' | 'unlocked') => {
    if(state === 'screen_off') {
      console.log('The screen has been turned off. The app is still kept alive.');
    }
  })
}

const heartbeat = ref(0);
window.addEventListener('message', (e) => {
  if(e.data?.action == 'heartbeat') {
    heartbeat.value = e.data.payload?.index;
  }
})

const selectMedia = () => {
  openModalSheet({
    name: 'select_media',
    description: 'Select a photo you want to be shown!',
    options: {
      limit: 1,
      allowTake: true,
      allowedTypes: [ 'image' ]
    },
    callback: (data: Attachment<AttachmentType.media>[]) => {
      if(!data.length) return;

      const { url } = data[0].content;
      selectedImage.value = url;
    }
  })
}

const selectGIF = () => {
  openModalSheet({
    name: 'gif',
    callback: (data: Attachment<AttachmentType.media>[]) => {
      if(!data.length) return;

      const { url } = data[0].content;
      selectedGIF.value = url;
    }
  })
}

const openDummyModal = () => {
  openModal({
    title: 'Title',
    description: 'Description',
    buttons: [
        {
            type: 'confirm',
            label: 'Confirm',
            callback: () => {
                console.log('Confirmed!')
            }
        },
        {
            type: 'cancel',
            label: 'Cancel',
            callback: () => {}
        }
    ]
});
}

const getCoords = async () => {
  coordinates.value = await emitNui('getCoords');
}

// Refs
const selectedImage = shallowRef<string | null>(null);
const selectedGIF = shallowRef<string | null>(null);
const coordinates = shallowRef<{ x: number, y: number, z: number } | null>(null);
</script>

<template>
  <PhoneFrame>
    <div class="container" :data-theme="darkMode ? 'dark' : 'light'">
      <div class="header">
        <h3>Vue - Custom Application</h3>
        <p>This is an example application</p>
      </div>

      <p class="label">Heartbeat {{ heartbeat }}</p>

      <p class="label">Selecting Media</p>
      <img :src="selectedImage" v-if="selectedImage">
      <button @click="selectMedia">Select Media</button>

      <p class="label">Selecting GIFs</p>
      <img :src="selectedGIF" v-if="selectedGIF">
      <button @click="selectGIF">Select GIF</button>

      <p class="label">Get your coordinates</p>
      <p class="description" v-if="coordinates">{{ coordinates?.x + ', ' + coordinates?.y + ', ' + coordinates?.z }}</p>
      <button @click="getCoords">Get coordinates</button>

      <p class="label">Test modal</p>
      <button @click="openDummyModal">Open</button>
    </div>
  </PhoneFrame>
</template>

<style scoped>
.container {
  width: 100%;
  min-height: 100%;
  height: auto;
  background-color: rgb(43, 43, 43);

  padding-bottom: 4em;

  text-align: center;
  color: white;

  box-sizing: border-box;
}

.container > .header {
  display: flex;
  flex-direction: column;
  justify-content: center;

  width: 100%;
  height: 8em;

  background-color: rgba(255, 255, 255, 0.2);
  border-radius: 2em;
  
  margin: 0 0 1em;
  padding-top: var(--header-height);
}

.container > .label {
  margin: 0.5em 0;
}

.container > img {
  width: 90%;
}

.container > .description {
  margin: 0.5em 0;
  font-size: 0.9em;

  opacity: 0.6;
}

.container > button {
  width: 90%;
  font-size: 1em;
  height: 2em;

  border-radius: 0.5em;
}

.container[data-theme="light"] {
  color: black;
  background-color: rgb(255, 255, 255);
}

.container[data-theme="light"] > .header {
  color: black;
  background-color: rgba(0, 0, 0, 0.2);
}

.container[data-theme="light"] > button {
  color: white;
  background-color: black;
}
</style>
