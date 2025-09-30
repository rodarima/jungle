builtins.mapAttrs (name: value: { email = name + "@bsc.es"; } // value) {
  abonerib.name = "Aleix Boné";
  arocanon.name = "Aleix Roca";
  rarias.name = "Rodrigo Arias";
  rpenacob.name = "Raúl Peñacoba";
  varcila.name = "Vincent Arcila";
}
