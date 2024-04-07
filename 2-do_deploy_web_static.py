#!/usr/bin/python3
from fabric.api import local, get, env
from time import strftime
from datetime import date
from os import path


filename = strftime("%Y%m%d%H%M%S")
env.hosts = ["54.164.5.211", "100.26.122.39"]
env.user = "ubuntu"


def do_deploy(archive_path):
    """ a Fabric script that distributes an archive to your web servers"""

    try:
        if not path.exists(archive_path):
            return False

        get(archive_path, remote=f"/tmp/web_static_{filename}")
        run(f"sudo mkdir -p /data/web_static/releases/")
        run(f"sudo tar -xvzf web_static_{filename} -C \
/data/web_static/releases/web_static_{filename}")
        run(f"sudo rm -fr /tmp/web_static_{filename}")
        run(f"sudo -fr rm /data/web_static/current")
        run(f"sudo ln -s -f /data/web_static/releases/web_static_{filename} \
/data/web_static/current")
        return True
    except Exception:
        return False
