<template>
  <button
    :class="{
      active: isActive,
    }"
  >
    {{ label }}
  </button>
</template>

<script>
export default {
  name: "MenuButton",
  props: {
    label: String,
    selectedPage: String,
    isActive: {
      type: Boolean,
      require: false,
      default: false
    }
  }
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped lang="scss">
.enabled {
  flex-grow: 1;
  border-radius: 0px;
  height: 5vh;
  border: 0px #fff solid;
  font-family: "robotoslab";
  font-weight: 500;
  letter-spacing: 1.5px;
  font-size: 15px;
  color: #9e9e9e;
  background-color: transparent;
  align-items: center;
}

.disabled-btn {
  flex-grow: 1;
  border-radius: 0px;
  height: 5vh;
  border: 0px #fff solid;
  font-family: "robotoslab";
  font-weight: 500;
  letter-spacing: 1.5px;
  font-size: 15px;
  color: #4b4a4a;
  background-color: transparent;
}

.enabled:hover {
  background: url("../assets/img/input.png");
  background-size: 100% 100%;
  color: #f0f0f0;
}

.enabled.active {
  background: url("../assets/img/input.png");
  background-size: 100% 100%;
  color: #f0f0f0;
}
</style>
