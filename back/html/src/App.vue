<template>
  <v-app id="inspire">
    <v-dialog v-model="dialog" width="500">
      <v-card>
        <v-card-title class="text-h5 grey lighten-2"> Novo vídeo </v-card-title>
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
      <v-btn color="success" dark @click="dialog = true">Adicionar novo</v-btn>
    </v-app-bar>

    <v-main>
      <template v-for="(video, index) of videos">
        <v-container v-if="video.path.indexOf('.mp4') != -1" :key="index">
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
        <img
          v-else
          :src="server_url + '/public/' + video.path"
          alt=""
          :key="index"
          class="border"
        />
      </template>
    </v-main>
  </v-app>
</template>

<script>
export default {
  data: function () {
    return {
      server_url: "https://tescaa.loca.lt",
      drawer: false,
      dialog: false,
      videos: [],
      listaCategorias: [],
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
    async buscar(i) {
      console.log("buscar acionado");
      this.videos = await (
        await fetch(this.server_url + "/categorias/" + i.categoria)
      ).json();
      console.log(`Variavel this.videos: `, this.videos);
    },
  }
</script>
<style scoped>
@import url("https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css");
</style>