<template>
  <div id="content" v-if="visible || devmode">
    <router-view />
  </div>
</template>
<script>
import "@/assets/css/style.css";
export default {
  name: "DefaultLayout",
  data() {
    return {
      devmode: false,
      visible: false,
    };
  },
  mounted() {
    window.addEventListener("message", this.onMessage);
  },
  methods: {
    onMessage(event) {
      switch (event.data.action) {
        case "show":
          this.visible = true;
          this.$store.dispatch("setBoats", event.data.shopData);
          this.$store.dispatch("setShopName", event.data.location);
          this.$store.dispatch("setTranslations", event.data.translations);
          this.$store.dispatch("setCurrencyType", event.data.currencyType);
          this.$store.dispatch("setMyBoats", event.data.myBoatsData);
          break;
        case "hide":
          this.visible = false;
          this.$store.dispatch("setMyBoats", null);
          this.$store.dispatch("setBoats", null);
          this.$store.dispatch("setShopName", null);
          this.$store.dispatch("setTranslations", null);
          this.$store.dispatch("setSelectedBoat", null);
          this.$store.dispatch("setAllowSave", false);
          this.$store.dispatch("setCurrencyType", null);
          break;
        default:
          break;
      }
    },
  },
};
</script>
<style lang="scss">
#content {
  overflow: hidden;
}
</style>
