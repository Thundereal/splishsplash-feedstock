About splishsplash-feedstock
============================

Feedstock license: [BSD-3-Clause](https://github.com/Thundereal/splishsplash-feedstock/blob/main/LICENSE.txt)

Home: https://github.com/InteractiveComputerGraphics/SPlisHSPlasH

Package license: MIT

Summary: SPlisHSPlasH's simulation libraries, for programs that step it themselves

Development: https://github.com/InteractiveComputerGraphics/SPlisHSPlasH

The static libraries and headers of SPlisHSPlasH (SPH fluids: DFSPH
and others) with the three libraries of its authors it is built on,
and no GUI, simulator or Python module. A CMake package
(find_package(SPlisHSPlasH CONFIG), target SPlisHSPlasH::SPlisHSPlasH)
hands a program the definitions, the vector instructions and the
bundled Eigen 3.4 the libraries were compiled with: a program must be
compiled the same way, and with that Eigen rather than the
environment's.


Current build status
====================


<table><tr>
    <td>GitHub Actions</td>
    <td>
      <a href="https://github.com/Thundereal/splishsplash-feedstock/actions/workflows/conda-build.yml">
        <img src="https://github.com/Thundereal/splishsplash-feedstock/actions/workflows/conda-build.yml/badge.svg?event=push&branch=main">
      </a>
    </td>
  </tr>
</table>

Current release info
====================

| Name | Downloads | Version | Platforms |
| --- | --- | --- | --- |
| [![Conda Recipe](https://img.shields.io/badge/recipe-splishsplash-green.svg)](https://anaconda.org/realthunder/splishsplash) | [![Conda Downloads](https://img.shields.io/conda/dn/realthunder/splishsplash.svg)](https://anaconda.org/realthunder/splishsplash) | [![Conda Version](https://img.shields.io/conda/vn/realthunder/splishsplash.svg)](https://anaconda.org/realthunder/splishsplash) | [![Conda Platforms](https://img.shields.io/conda/pn/realthunder/splishsplash.svg)](https://anaconda.org/realthunder/splishsplash) |

Installing splishsplash
=======================

Installing `splishsplash` from the `realthunder` channel can be achieved by adding `realthunder` to your channels with:

```
conda config --add channels realthunder
conda config --set channel_priority strict
```

How to use
----------

<details>
<summary>With conda</summary>

```
conda install splishsplash
```

</details>

<details>
<summary>With mamba</summary>

```
mamba install splishsplash
```

</details>

<details>
<summary>With pixi</summary>

```
# for adding to your local project
pixi add splishsplash
# for installing globally
pixi global install splishsplash
```

</details>

Search package versions
-----------------------

It is possible to list all of the versions of `splishsplash` available on your platform:

<details>
<summary>With conda</summary>

```
conda search splishsplash --channel realthunder
```

</details>

<details>
<summary>With mamba</summary>

```
mamba search splishsplash --channel realthunder
```

</details>

<details>
<summary>With pixi</summary>

```
pixi search splishsplash --channel realthunder
```

</details>

<details>
<summary>With mamba repoquery, which may provide more information</summary>

```
# Search all versions available on your platform:
mamba repoquery search splishsplash --channel realthunder

# List packages depending on `splishsplash`:
mamba repoquery whoneeds splishsplash --channel realthunder

# List dependencies of `splishsplash`:
mamba repoquery depends splishsplash --channel realthunder
```

</details>




Updating splishsplash-feedstock
===============================

If you would like to improve the splishsplash recipe or build a new
package version, please fork this repository and submit a PR. Upon submission,
your changes will be run on the appropriate platforms to give the reviewer an
opportunity to confirm that the changes result in a successful build. Once
merged, the recipe will be re-built and uploaded automatically to the
`realthunder` channel, whereupon the built conda packages will be available for
everybody to install and use from the `realthunder` channel.
Note that all branches in the Thundereal/splishsplash-feedstock are
immediately built and any created packages are uploaded, so PRs should be based
on branches in forks, and branches in the main repository should only be used to
build distinct package versions.

In order to produce a uniquely identifiable distribution:
 * If the version of a package **is not** being increased, please add or increase
   the [``build/number``](https://docs.conda.io/projects/conda-build/en/latest/resources/define-metadata.html#build-number-and-string).
 * If the version of a package **is** being increased, please remember to return
   the [``build/number``](https://docs.conda.io/projects/conda-build/en/latest/resources/define-metadata.html#build-number-and-string)
   back to 0.

Feedstock Maintainers
=====================

* [@realthunder](https://github.com/realthunder/)

