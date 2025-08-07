import { createRouter, createWebHashHistory } from "vue-router";
import BoatMenu from "../views/BoatMenu.vue";

const routes = [
  {
    path: "/",
    name: "home",
    component: BoatMenu,
  },
];

const router = createRouter({
  history: createWebHashHistory(),
  routes,
});

export default router;
