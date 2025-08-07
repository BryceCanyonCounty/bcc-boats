<template>
  <div class="container">
    <!--  -->
    <div class="panel">
      <div class="panel-title" @click="[SelectBoat(), Expand()]">
        <h6 class="grey-text plus">
          <span
            class="material-icons center active-boat mr"
            v-if="isActive"
          >&#xe5cb;</span>
          {{ label }}
          <span
            class="material-icons center active-boat ml"
            v-if="isActive"
          >&#xe5cc;</span>
        </h6>
      </div>
    </div>
    <!--  -->
    <div v-if="isOpen" class="mb">
      <div></div>
      <!--  -->
      <div class="panel-myboat item">
        <button class="item-myboat" @click="RenameBoat()">{{ $store.getters.getTranslation('renamePersonalBoat') }}</button>
        <button class="item-myboat" @click="SpawnData()">{{ $store.getters.getTranslation('spawnPersonalBoat') }}</button>
        <button class="item-myboat" @click="toggleModal">{{ $store.getters.getTranslation('sellPersonalBoat') }}</button>
      </div>
      <!--  -->
      <div class=""></div>
    </div>
  </div>
  <ConfirmationModal :visible="showModal" title="Confirm" @close="toggleModal">
    <p style="text-align: center">{{ $store.getters.getTranslation('sellConfirmation') }}</p>
    <div class="divider-menu-top" style="margin-top: 1rem"></div>
    <div class="flex cta-wrapper">
      <button @click="SellBoat" class="modal-btn flex flex-auto">
        <img src="../assets/img/money.png" />{{ $store.getters.getTranslation('sellConfirmationButton') }}
      </button>
      <!--  -->
      <button @click="toggleModal" class="modal-btn flex flex-auto">
        {{ $store.getters.getTranslation('sellConfirmationCancelButton') }}
      </button>
    </div>
    <div class="divider-menu-bottom"></div>
  </ConfirmationModal>
</template>

<script>
import api from "@/api";
import { mapState } from "vuex";
import ConfirmationModal from "./ConfirmationModal.vue";

export default {
  name: "MyBoatMenuItem",
  props: {
    label: String,
    index: Number,
    model: String,
    selected: Number,
    boat: Object,
  },
  data() {
    return {
      showModal: false,
    };
  },
  emits: ["iExpanded"],
  computed: {
    ...mapState(["activeBoat"]),
    isOpen() {
      return this.index == this.selected;
    },
    isActive() {
      return this.activeBoat && this.index == this.activeBoat["id"];
    },
  },
  methods: {
    Expand() {
      if (!this.isOpen) {
        this.$emit("iExpanded", this.index);
      }
    },
    SelectBoat() {
      if (!this.isOpen) {
        this.$store.dispatch("setSelectedBoat", this.boat);
        api
          .post("SelectBoat", {
            boatId: this.index,
          })
          .catch((e) => {
            console.log(e.message);
          });

        api.post("LoadMyBoat", {
          boatId: this.index,
          boatModel: this.model,
        });
      }
    },
    RenameBoat() {
      api
        .post("RenameBoat", {
          boatId: this.index,
        })
        .catch((e) => {
          console.log(e.message);
        });
    },
    SpawnData() {
      api
        .post("SpawnData", {
          boatId: this.index,
          boatModel: this.model,
          boatName: this.label,
        })
        .then(() => {
        return api.post("CloseBoat", {
            MenuAction: "Close",
        });
        })
        .catch((e) => {
        console.log(e.message);
        });
    },
    SellBoat() {
      api
        .post("SellBoat", {
          boatId: this.index,
          boatModel: this.model,
          boatName: this.label,
        })
        .catch((e) => {
          console.log(e.message);
        });
    },
    toggleModal() {
      this.showModal = !this.showModal;
    },
  },
  components: {
    ConfirmationModal,
  },
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped lang="scss">
.container {
  width: 96%;
  margin: auto;
  overflow: hidden;
}
.mb {
  margin-bottom: 0.25rem;
}
.panel {
  padding: 0px;
  margin: 3px 10px;
  border-radius: 0px;
  width: calc(100% - 20px);
  background-color: transparent;
  overflow: hidden;
  background: url("../assets/img/input.png");
  background-size: 100% 100%;
}

.panel-title {
  background-size: 100% 100%;
  padding: 10px 10px;
  font-size: 1.5em;
  font-weight: 400;
  text-align: center;
}

.panel-title .grey-text {
  color: #9e9e9e;
  margin: 0;
  margin-top: 5px;
  margin-bottom: 5px;
}

.panel-myboat.item {
  width: calc(100% - 60px);
  background-image: url("../assets/img/input.png"),
    url("../assets/img/input.png");
  background-position: center center;
  background-repeat: no-repeat;
  background-size: 100% 100%;
  margin: auto;
}

.item {
  display: flex;
  justify-content: left;
  padding: 3px 3px;
}

.item-myboat {
  /*height: 3vh;*/
  border: 0px #fff solid;
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 5px 3px;
  width: 50%;
  margin: auto;
  color: #9e9e9e;
  text-align: center;
}

.item-myboat:hover {
  background: url("../assets/img/buttonv.png");
  background-size: 90% 100%;
  background-position: center;
  background-repeat: no-repeat;
  color: #f0f0f0;
}

.grey-text.plus:hover {
  color: #f0f0f0;
}

.active-boat {
  color: #d89a2e;
  font-size: 16px;
}

.mr {
  margin-right: 5px;
}

.ml {
  margin-left: 5px;
}
.flex {
  display: flex;
}
.flex-auto {
  flex: 1 1 auto;
}
.modal-btn {
  flex-direction: row;
  justify-content: center;
  align-items: center;
  text-decoration: none;
  color: #f0f0f0;
  user-select: none;
  text-align: left;
  width: 75px;
  letter-spacing: 0.5px;
  -webkit-transition: background-color 0.2s ease-out;
  transition: background-color 0.2s ease-out;
  border: 0px #fff solid;
}
.modal-btn:hover {
  background: url("../assets/img/buttonv.png");
  background-size: 90% 100%;
  background-repeat: no-repeat;
  background-position: right;
  border-radius: 0px;
}
.cta-wrapper {
  background: url("../assets/img/input.png");
  background-position: center;
  background-size: 100% 100%;
  height: 4vh;
}

.divider-menu-top,
.divider-menu-bottom {
  width: 90%;
  height: 4px;
  margin: auto auto;
  background-image: url("../assets/img/divider_line.png");
  background-repeat: no-repeat;
  background-position: center;
  background-size: 100% 100%;
  opacity: 0.6;
}

.divider-menu-top {
  margin-bottom: 10px;
}

.divider-menu-bottom {
  margin-top: 10px;
}
</style>
