(function(e){function r(r){for(var n,i,c=r[0],s=r[1],l=r[2],f=0,d=[];f<c.length;f++)i=c[f],Object.prototype.hasOwnProperty.call(a,i)&&a[i]&&d.push(a[i][0]),a[i]=0;for(n in s)Object.prototype.hasOwnProperty.call(s,n)&&(e[n]=s[n]);u&&u(r);while(d.length)d.shift()();return o.push.apply(o,l||[]),t()}function t(){for(var e,r=0;r<o.length;r++){for(var t=o[r],n=!0,c=1;c<t.length;c++){var s=t[c];0!==a[s]&&(n=!1)}n&&(o.splice(r--,1),e=i(i.s=t[0]))}return e}var n={},a={app:0},o=[];function i(r){if(n[r])return n[r].exports;var t=n[r]={i:r,l:!1,exports:{}};return e[r].call(t.exports,t,t.exports,i),t.l=!0,t.exports}i.m=e,i.c=n,i.d=function(e,r,t){i.o(e,r)||Object.defineProperty(e,r,{enumerable:!0,get:t})},i.r=function(e){"undefined"!==typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(e,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(e,"__esModule",{value:!0})},i.t=function(e,r){if(1&r&&(e=i(e)),8&r)return e;if(4&r&&"object"===typeof e&&e&&e.__esModule)return e;var t=Object.create(null);if(i.r(t),Object.defineProperty(t,"default",{enumerable:!0,value:e}),2&r&&"string"!=typeof e)for(var n in e)i.d(t,n,function(r){return e[r]}.bind(null,n));return t},i.n=function(e){var r=e&&e.__esModule?function(){return e["default"]}:function(){return e};return i.d(r,"a",r),r},i.o=function(e,r){return Object.prototype.hasOwnProperty.call(e,r)},i.p="/html/";var c=window["webpackJsonp"]=window["webpackJsonp"]||[],s=c.push.bind(c);c.push=r,c=c.slice();for(var l=0;l<c.length;l++)r(c[l]);var u=s;o.push([0,"chunk-vendors"]),t()})({0:function(e,r,t){e.exports=t("56d7")},"1e30":function(e,r,t){},"56d7":function(e,r,t){"use strict";t.r(r);t("e260"),t("e6cf"),t("cca6"),t("a79d");var n=t("2b0e"),a=function(){var e=this,r=e.$createElement,t=e._self._c||r;return t("v-app",{attrs:{id:"inspire"}},[t("v-dialog",{attrs:{width:"500"},model:{value:e.dialog,callback:function(r){e.dialog=r},expression:"dialog"}},[t("v-card",[t("v-card-title",{staticClass:"text-h5 grey lighten-2"},[e._v(" Novo vídeo ")]),""!=e.form.erro?t("v-alert",{attrs:{outlined:"",type:"warning",prominent:"",border:"left"}},[e._v(" "+e._s(e.form.erro)+" ")]):e._e(),t("v-card-text",[[t("v-col",[t("v-text-field",{attrs:{label:"Digite a categoria",rules:e.form.rules.categoria},on:{keypress:function(r){e.form.erro=""}},model:{value:e.form.categoria,callback:function(r){e.$set(e.form,"categoria",r)},expression:"form.categoria"}})],1),t("v-divider"),t("v-col",{attrs:{md:"12"}},[t("v-file-input",{attrs:{"prepend-icon":"mdi-video-check",accept:".mp4",label:"Selecione o vídeo"},on:{focus:function(r){e.form.erro=""}},model:{value:e.form.file,callback:function(r){e.$set(e.form,"file",r)},expression:"form.file"}})],1),t("v-col",{attrs:{md:"12"}},[t("v-text-field",{attrs:{label:"Digite a url","hide-details":"auto",rules:e.form.rules.url,"append-icon":"mdi-content-paste"},on:{"click:append":e.paste,keypress:function(r){e.form.erro=""}},model:{value:e.form.url,callback:function(r){e.$set(e.form,"url",r)},expression:"form.url"}})],1)]],2),t("v-divider"),t("v-card-actions",[t("v-spacer"),t("v-btn",{attrs:{color:"success",text:""},on:{click:function(r){return e.enviar()}}},[e._v(" Enviar ")])],1)],1)],1),t("v-navigation-drawer",{attrs:{absolute:"",left:"",temporary:""},model:{value:e.drawer,callback:function(r){e.drawer=r},expression:"drawer"}},[t("v-list",{attrs:{nav:"",dense:""}},[t("p",[e._v("Categorias")]),t("v-divider"),t("v-divider"),t("v-list-item-group",{attrs:{"active-class":"deep-purple--text text--accent-4"}},e._l(e.listaCategorias,(function(r,n){return t("v-list-item",{key:n},[t("v-list-item-title",{on:{click:function(t){e.buscar(r),e.drawer=!1}}},[e._v(e._s(r.categoria))])],1)})),1)],1)],1),t("v-app-bar",{attrs:{app:""}},[t("v-app-bar-nav-icon",{on:{click:function(r){e.drawer=!e.drawer}}}),t("v-toolbar-title",[e._v("Categorias")]),t("v-spacer"),t("v-btn",{attrs:{color:"success",dark:""},on:{click:function(r){e.dialog=!0}}},[e._v("Adicionar novo")])],1),t("v-main",[e._l(e.videos,(function(r,n){return[-1!=r.path.indexOf(".mp4")?t("v-container",{key:n},[t("v-row",[t("v-col",[e._v(e._s(r.filename))])],1),t("v-row",[t("v-col",[t("div",{staticClass:"embed-responsive embed-responsive-16by9"},[t("video",{attrs:{controls:"",src:e.server_url+"/public/"+r.path}})])])],1)],1):t("img",{key:n,staticClass:"border",attrs:{src:e.server_url+"/public/"+r.path,alt:""}})]}))],2)],1)},o=[],i=t("1da1"),c=(t("96cf"),t("d3b7"),{data:function(){return{server_url:"https://tescaa.loca.lt",drawer:!1,dialog:!1,videos:[],listaCategorias:[],form:{erro:"",file:[],url:"",categoria:"",rules:{url:[function(e){return!!e||"Required."},function(e){return!!e&&-1!=e.indexOf("https://")||"Precisa começar com https://."}],categoria:[function(e){return!!e||"Categoria necessária."}]}}}},mounted:function(){var e=this;return Object(i["a"])(regeneratorRuntime.mark((function r(){var t;return regeneratorRuntime.wrap((function(r){while(1)switch(r.prev=r.next){case 0:return r.next=2,fetch(e.server_url+"/videos");case 2:return r.next=4,r.sent.json();case 4:return t=r.sent,r.next=7,fetch(e.server_url+"/categorias");case 7:return r.next=9,r.sent.json();case 9:e.listaCategorias=r.sent,e.videos=t,console.log("Variavel this.listaCategorias: ",e.listaCategorias);case 12:case"end":return r.stop()}}),r)})))()},methods:{paste:function(){var e=this;return Object(i["a"])(regeneratorRuntime.mark((function r(){return regeneratorRuntime.wrap((function(r){while(1)switch(r.prev=r.next){case 0:return r.next=2,navigator.clipboard.readText();case 2:e.form.url=r.sent;case 3:case"end":return r.stop()}}),r)})))()},enviar:function(){var e=this;return Object(i["a"])(regeneratorRuntime.mark((function r(){var t,n,a;return regeneratorRuntime.wrap((function(r){while(1)switch(r.prev=r.next){case 0:if(""!=e.form.categoria){r.next=2;break}return r.abrupt("return",e.form.erro="Sem categoria");case 2:if(""!=e.form.url||null!=e.form.file&&0!=e.form.file.length){r.next=4;break}return r.abrupt("return",e.form.erro="Insira ao menos um vídeo ou a url para baixá-lo do YT");case 4:if(!(e.form.file.length>0&&null!=e.form.file)){r.next=15;break}return t=new FormData,t.append("categoria",e.form.categoria),console.log("Variavel this.form.file: ",e.form.file),t.append("file",e.form.file),r.next=11,fetch("http://localhost/uploadFile",{method:"POST",body:t});case 11:n=r.sent,200==n.status&&(e.dialog=!1,e.iniciar()),r.next=19;break;case 15:return r.next=17,fetch("http://localhost/videos",{method:"POST",headers:{Accept:"application/json","Content-Type":"application/json"},body:JSON.stringify({url:e.form.url,categoria:e.form.categoria})});case 17:a=r.sent,200==a.status&&(e.dialog=!1,e.iniciar());case 19:case"end":return r.stop()}}),r)})))()}},buscar:function(e){var r=this;return Object(i["a"])(regeneratorRuntime.mark((function t(){return regeneratorRuntime.wrap((function(t){while(1)switch(t.prev=t.next){case 0:return console.log("buscar acionado"),t.next=3,fetch(r.server_url+"/categorias/"+e.categoria);case 3:return t.next=5,t.sent.json();case 5:r.videos=t.sent,console.log("Variavel this.videos: ",r.videos);case 7:case"end":return t.stop()}}),t)})))()}}),s=c,l=(t("a54a"),t("2877")),u=Object(l["a"])(s,a,o,!1,null,"18307854",null),f=u.exports,d=t("ce5b"),p=t.n(d);t("bf40");n["default"].use(p.a);var v=new p.a({theme:{themes:{light:{primary:"#007BFF",secondary:"#424242",accent:"#82B1FF",error:"#FF5252",info:"#2196F3",success:"#4CAF50",warning:"#FFC107"}}}});t("5363");n["default"].config.productionTip=!1,new n["default"]({vuetify:v,render:function(e){return e(f)}}).$mount("#app")},a54a:function(e,r,t){"use strict";t("1e30")}});
//# sourceMappingURL=app.38020a76.js.map