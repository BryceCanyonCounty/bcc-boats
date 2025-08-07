<template>
  <div v-if="myBoats">
    <div v-if="Object.keys(myBoats).length">
      <div>
        <MyBoatMenuItem
          :label="boat.name"
          :index="boat.id"
          :model="boat.model"
          :boat="boat"
          :selected="activeDropdown"
          v-for="(boat, index) in myBoats"
          :key="index"
          @iExpanded="onChildExpansion($event)"
        />
      </div>
    </div>
    <div v-else>
      <div class="text">
        <div class="container">
          <div class="flex panel">
            <div class="flex flex-auto panel-title">
              <h6 class="grey-text plus">
                {{ $store.getters.getTranslation('noPersonalBoat') }}
              </h6>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div v-else>
    <img src="../assets/img/6cyl_revolver.png" alt="" class="image" />
  </div>
</template>

<script>
import { mapState } from "vuex";
import MyBoatMenuItem from "./MyBoatMenuItem.vue";
export default {
  name: "MyBoatMenu",
  data() {
    return {
      activeDropdown: -1,
    };
  },
  methods: {
    onChildExpansion(event) {
      this.activeDropdown = event;
    },
  },
  components: {
    MyBoatMenuItem,
  },
  computed: mapState(["myBoats", "activeBoat"]),
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped lang="scss">
.loading-text {
  color: #f0f0f0;
  text-align: center;
  font-size: 1.15em;
}

.image {
  position: absolute;
  top: 50%;
  left: 50%;
  width: 120px;
  height: 120px;
  margin: -60px 0 0 -60px;
  -webkit-animation: spin 4s linear infinite;
  -moz-animation: spin 4s linear infinite;
  animation: spin 4s linear infinite;
  opacity: 0.15;
}

@-moz-keyframes spin {
  100% {
    -moz-transform: rotate(360deg);
  }
}

@-webkit-keyframes spin {
  100% {
    -webkit-transform: rotate(360deg);
  }
}

@keyframes spin {
  100% {
    -webkit-transform: rotate(360deg);
    transform: rotate(360deg);
  }
}

.container {
  width: 96%;
  margin: auto;
  overflow: hidden;
}

.flex {
  display: flex;
}

.flex-auto {
  flex: 0 1 auto;
}

.panel {
  padding: 0px;
  margin: 3px 10px;
  border-radius: 0px;
  // width: calc(100% - 20px) !important;
  background-color: transparent;
  overflow: hidden;
  background: url("../assets/img/input.png");
  background-size: 100% 100%;
  justify-content: center;
}

.panel-title {
  background-size: 100% 100%;
  padding: 10px 10px;
  font-size: 1.5em;
  font-weight: 400;
  text-align: center;
}

.panel-title .grey-text {
  margin: 0;
  margin-top: 5px;
  margin-bottom: 5px;
}

.panel-title .grey-text {
  color: #9e9e9e;
  margin: 0;
  margin-top: 5px;
  margin-bottom: 5px;
}
</style>
