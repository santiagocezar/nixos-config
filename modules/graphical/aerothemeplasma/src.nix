pkgs:

pkgs.fetchgit {
  url = "https://gitgud.io/wackyideas/aerothemeplasma";
  rev = "42455c4640e9a4fa45cb141153ef84d7ff688fff";
  sha256 = "137l426blx6b6pd5icbms9aq94l9r7v7jhw21irnag5081m27xrc";
  fetchLFS = false;
  fetchSubmodules = false;
  deepClone = false;
  leaveDotGit = false;
}
