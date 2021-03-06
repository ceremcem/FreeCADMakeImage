import sys
import os
import subprocess
import platform
import jinja2

platform_dict = {}
platform_dict["Darwin"] = "OSX"

sys_n_arch = platform.platform()
sys_n_arch = sys_n_arch.split("-")
system, arch = sys_n_arch[0], sys_n_arch[2]
if system in platform_dict:
    system = platform_dict[system]

version_info = subprocess.check_output("FreeCADCmd --version", shell=True)
version_info = version_info.decode("utf-8").split(" ")
dev_version = version_info[1]
revision = version_info[3]

if system == "OSX":
    with open("Info.plist.template") as template_file:
        template_str = template_file.read()
    template = jinja2.Template(template_str)
    rendered_str = template.render(FREECAD_VERSION="{}-{}".format(dev_version, revision),
                                APPLICATION_MENU_NAME="FreeCAD-{}-{}".format(dev_version, revision))
    with open("MacBundle/FreeCAD.app/Contents/Info.plist", "w") as rendered_file:
        rendered_file.write(rendered_str)

print("{}-{}-{}".format(revision, system, arch))
