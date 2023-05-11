{ lib, ... }:

{
  # Disable frequency boost by default. Use the intel_pstate driver instead of
  # acpi_cpufreq driver because the acpi_cpufreq driver does not read the
  # complete range of P-States [1]. Use the intel_pstate passive mode [2] to
  # disable HWP, which allows a core to "select P-states by itself". Also, this
  # disables intel governors, which confusingly, have the same names as the
  # generic ones but behave differently [3].

  # Essentially, we use the generic governors, but use the intel driver to read
  # the P-state list.

  # [1] - https://www.kernel.org/doc/html/latest/admin-guide/pm/intel_pstate.html#intel-pstate-vs-acpi-cpufreq
  # [2] - https://www.kernel.org/doc/html/latest/admin-guide/pm/intel_pstate.html#passive-mode
  # [3] - https://www.kernel.org/doc/html/latest/admin-guide/pm/intel_pstate.html#active-mode
  # https://www.kernel.org/doc/html/latest/admin-guide/pm/cpufreq.html

  # set intel_pstate to passive mode
  boot.kernelParams = [
    "intel_pstate=passive"
  ];
  # Disable frequency boost
  system.activationScripts = {
    disableFrequencyBoost.text = ''
      echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo
    '';
  };

  ## disable intel_pstate
  #boot.kernelParams = [
  #  "intel_pstate=disable"
  #];
  ## Disable frequency boost
  #system.activationScripts = {
  #  disableFrequencyBoost.text = ''
  #    echo 0 > /sys/devices/system/cpu/cpufreq/boost
  #  '';
  #};
}
