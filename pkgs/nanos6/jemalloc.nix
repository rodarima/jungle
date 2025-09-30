{ jemalloc, lib }:

jemalloc.overrideAttrs (old: {
  configureFlags = old.configureFlags ++ [
    "--with-jemalloc-prefix=nanos6_je_"
    "--enable-stats"
  ];
  hardeningDisable = [ "all" ];
  meta = old.meta // {
    description = old.meta.description + " (for Nanos6)";
    maintainers = (old.meta.maintainers or []) ++ (with lib.maintainers.bsc; [ rarias ]);
  };
})
