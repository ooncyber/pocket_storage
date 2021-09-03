<template>
  <v-app>
    <v-main>
      <div class="d-none d-sm-flex">
        <v-app-bar color="orange">
          <v-toolbar-title
            ><v-btn class="secondary mr-5" href="/"
              >Categorias
            </v-btn></v-toolbar-title
          >
          <span v-for="(i, index) in listaCategorias" :key="index">
            <v-btn
              :class="{ primary: indexAtivo == index }"
              class="mr-5"
              @click="
                buscar(i);
                indexAtivo = index;
              "
              href="#"
              >{{ i.categoria }}
            </v-btn>
          </span>
          <v-spacer></v-spacer>
          <v-btn class="success" @click="dialog = true">
            <v-icon large class="mr-5">mdi-plus-circle-outline</v-icon>
            Adicionar outro</v-btn
          >
        </v-app-bar>
      </div>
      <div class="d-flex d-sm-none">
        <!-- celular -->
        <v-app-bar
          color="deep-purple"
          dark
          v-touch="{
            left: () => swipe('Left'),
            right: () => swipe('Right'),
            up: () => swipe('Up'),
            down: () => swipe('Down'),
          }"
        >
          <v-app-bar-nav-icon @click="drawer = true"></v-app-bar-nav-icon>

          <v-toolbar-title> Categorias</v-toolbar-title>
        </v-app-bar>

        <!-- drawer -->

        <v-navigation-drawer v-model="drawer" absolute left temporary>
          <v-list nav dense>
            <p>Categorias</p>
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
        <!-- fim drawer -->
        <!-- fim celular -->
      </div>

      <v-dialog v-model="dialog" width="500">
        <v-card>
          <v-card-title class="text-h5 grey lighten-2">
            Novo vídeo
          </v-card-title>
          <v-alert
            outlined
            type="warning"
            prominent
            border="left"
            v-if="form.erro != ''"
          >
            {{ form.erro }}
          </v-alert>
          <v-card-text>
            <template>
              <v-col>
                <v-text-field
                  label="Digite a categoria"
                  v-model="form.categoria"
                  :rules="form.rules.categoria"
                  @keypress="form.erro = ''"
                >
                </v-text-field>
              </v-col>
              <v-divider></v-divider>
              <v-col md="12">
                <v-file-input
                  v-model="form.file"
                  prepend-icon="mdi-video-check"
                  accept=".mp4"
                  label="Selecione o vídeo"
                  @focus="form.erro = ''"
                ></v-file-input>
              </v-col>
              <v-col md="12">
                <v-text-field
                  v-model="form.url"
                  label="Digite a url"
                  hide-details="auto"
                  :rules="form.rules.url"
                  append-icon="mdi-content-paste"
                  @click:append="paste"
                  @keypress="form.erro = ''"
                ></v-text-field>
              </v-col>
            </template>
          </v-card-text>

          <v-divider></v-divider>

          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="success" text @click="enviar()"> Enviar </v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>

      <v-container fluid>
        <v-col v-for="i in videos" :key="i.filename" class="mb-9">
          <v-row justify="center">
            <v-col>{{ i.filename }}</v-col>
          </v-row>
          <v-row justify="center">
            <v-col>
              <video controls :width="getWidth()">
                <source
                  :src="SERVER + 'public/videos/' + i.filename"
                  type="video/mp4"
                />
                Your browser does not support the video tag.
              </video>
            </v-col>
          </v-row>
        </v-col>

        <!-- <v-row
          v-for="i in videos"
          :key="i.filename"
        >
          <v-col>
            {{i.filename}}
            <video controls>
              <source
                :src="SERVER + 'public/videos/' + i.filename"
                type="video/mp4"
              />
              Your browser does not support the video tag.
            </video>
            
          </v-col>
        </v-row> -->
      </v-container>
    </v-main>
  </v-app>
</template>

<script>
export default {
  name: "App",
  data: function () {
    return {
      drawer: false,
      message: "oi",
      listaCategorias: [],
      videos: [],
      indexAtivo: -1,
      dialog: false,

      SERVER: "http://192.168.100.19/",
      form: {
        erro: "",
        file: [],
        url: "",
        categoria: "",
        rules: {
          url: [
            (value) => !!value || "Required.",
            (value) =>
              (!!value && value.indexOf("https://") != -1) ||
              "Precisa começar com https://.",
          ],
          categoria: [(value) => !!value || "Categoria necessária."],
        },
      },

      swipeDirection: "None",
    };
  },
  methods: {
    getWidth() {
      console.log(`Variavel window.innerHeight;: `, window.innerWidth);
      console.log(`Variavel window.innerHeight;: `, window.innerHeight);
      return window.innerWidth * 0.8;
    },
    swipe(direction) {
      this.swipeDirection = direction;
      if (direction == "Right") this.drawer = !this.drawer;
    },
    async iniciar() {
      this.form.file = [];
      this.form.url = "";
      this.form.categoria = "";
      this.listaCategorias = await (
        await fetch(this.SERVER + "categorias")
      ).json();
    },
    async buscar(i) {
      console.log(`Variavel this.indexAtivo: `, this.indexAtivo);
      this.videos = await (
        await fetch(this.SERVER + "categorias/" + i.categoria)
      ).json();
      console.log(`Variavel this.videos: `, this.videos);
    },
    async paste() {
      this.form.url = await navigator.clipboard.readText();
    },
    async enviar() {
      if (this.form.categoria == "") return (this.form.erro = "Sem categoria");
      if (
        this.form.url == "" &&
        (this.form.file == null || this.form.file.length == 0)
      )
        return (this.form.erro =
          "Insira ao menos um vídeo ou a url para baixá-lo do YT");

      if (this.form.file.length > 0 && this.form.file != null) {
        var formData = new FormData();
        formData.append("categoria", this.form.categoria);
        console.log(`Variavel this.form.file: `, this.form.file);
        formData.append("file", this.form.file);

        const response = await fetch("http://localhost/uploadFile", {
          method: "POST",
          body: formData,
        });
        if (response.status == 200) {
          this.dialog = false;
          this.iniciar();
        }
      } else {
        const response = await fetch("http://localhost/videos", {
          method: "POST",
          headers: {
            Accept: "application/json",
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            url: this.form.url,
            categoria: this.form.categoria,
          }),
        });
        if (response.status == 200) {
          this.dialog = false;
          this.iniciar();
        }
      }
    },
  },
  created: function () {
    this.iniciar();
  },
};
</script>
