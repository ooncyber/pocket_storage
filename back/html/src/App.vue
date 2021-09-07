<template>
  <v-app id="inspire">
    <v-navigation-drawer v-model="drawer" absolute left temporary>
      <v-list nav dense>
        <p>Categorias</p>
        <v-divider></v-divider>
        <v-divider></v-divider>
        <v-list-item-group active-class="deep-purple--text text--accent-4">
          <v-list-item v-for="(i, index) in listaCategorias" :key="index">
            <v-list-item-title
              @click="
                buscar(i);
                drawer = false;
              "
              >{{ i.categoria }}</v-list-item-title
            >
          </v-list-item>
        </v-list-item-group>
      </v-list>
    </v-navigation-drawer>
    <v-app-bar app>
      <v-app-bar-nav-icon @click="drawer = !drawer"></v-app-bar-nav-icon>

      <v-toolbar-title>Categorias</v-toolbar-title>
      <v-spacer></v-spacer>
      <v-btn color="success" dark>Adicionar novo</v-btn>
    </v-app-bar>

    <v-main>
      <v-container v-for="(video, index) of videos" :key="index">
        <v-row>
          <v-col>{{ video.filename }}</v-col>
        </v-row>
        <v-row>
          <v-col>
            <div class="embed-responsive embed-responsive-16by9">
              <video
                controls
                :src="server_url + '/public/' + video.path"
              ></video>
            </div>
          </v-col>
        </v-row>
      </v-container>
    </v-main>
  </v-app>
</template>

<script>
export default {
  data: function () {
    return {
      server_url: "http://localhost",
      drawer: false,
      videos: [],
      listaCategorias: [],
    };
  },
  async mounted() {
    let videos = await (await fetch(this.server_url + "/videos")).json();
    this.listaCategorias = await (
      await fetch(this.server_url + "/categorias")
    ).json();
    this.videos = videos;
    console.log(`Variavel this.listaCategorias: `, this.listaCategorias);
  },
  methods: {
    async buscar(i) {
      this.videos = await (
        await fetch(this.server_url + "/categorias/" + i.categoria)
      ).json();
      console.log(`Variavel this.videos: `, this.videos);
    },
  },
};
</script>
<style scoped>
@import url("https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css");
</style>