import { createStore } from "vuex";

export default createStore({
  state: {
    myBoats: null,
    boats: null,
    shopName: null,
    activeBoat: null,
    allowSave: false,
    currencyType: null,
    translations: {}
  },
  getters: {
    getTranslation: (state) => (key) => {
      return state.translations[key] ?? ''
    }
  },
  mutations: {
    SET_MY_BOATS(state, payload) {
      state.myBoats = payload;
    },
    SET_BOATS(state, payload) {
      state.boats = payload;
    },
    SET_SHOP_NAME(state, payload) {
      state.shopName = payload;
    },
    SET_TRANSLATIONS(state, payload) {
      state.translations = payload;
    },
    SET_SELECTED_BOAT(state, payload) {
      state.activeBoat = payload;
    },
    SET_ALLOW_SAVE(state, payload) {
      state.allowSave = payload;
    },
    SET_CURRENCY_TYPE(state, payload) {
      state.currencyType = payload;
    },
  },
  actions: {
    setMyBoats(context, payload) {
      context.commit("SET_MY_BOATS", payload);
    },
    setBoats(context, payload) {
      context.commit("SET_BOATS", payload);
    },
    setShopName(context, payload) {
      context.commit("SET_SHOP_NAME", payload);
    },
    setTranslations(context, payload) {
      context.commit("SET_TRANSLATIONS", payload);
    },
    setSelectedBoat(context, payload) {
      context.commit("SET_SELECTED_BOAT", payload);
    },
    setAllowSave(context, payload) {
      context.commit("SET_ALLOW_SAVE", payload);
    },
    setCurrencyType(context, payload) {
      context.commit("SET_CURRENCY_TYPE", payload);
    }
  },
  modules: {},
});
