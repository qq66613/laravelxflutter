<template>
  <div id="app">
    <DataDisplay />
  </div>
</template>

<script>
import DataDisplay from './components/DataDisplay.vue'

export default {
  name: 'App',
  components: {
    DataDisplay,
  }
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
