#!/usr/bin/env bash
from fabric import Connection, task
from datetime import datetime
import os


@task
def do_pack():
    FORMAT = '%Y%m%d%H%M%S'
    TIME = datetime.now().strftime(FORMAT)
    FILE_NAME = f"web_static_{TIME}.tgz"
    c = Connection(
        host="34.234.201.107",
        user="ubuntu",
        connect_kwargs={
            "key_filename": "/home/ayokayzy/.ssh/id_rsa",
        },
    )
    HOST = c.host
    print(f"Packing web_static to versions/{FILE_NAME}")
    print(f"[localhost] local: tar -czvf versions/{FILE_NAME} web_static/*")
    result = c.local("mkdir -p versions")
    if (result.ok):
        c.local(f"tar -czvf versions/{FILE_NAME} compress_file/* 2>/dev/null")
        file_size = os.path.getsize(f"versions/{FILE_NAME}")
        print(f"web_static packed: versions/{FILE_NAME} -> {file_size}Bytes")
    else:
        print("None")
