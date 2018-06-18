import argparse
import os
import pathlib
import subprocess
import re


def main():
    args = parse_args()
    print(version_from_git(args.workdir))
    print(vars(args))


def version_from_git(workdir):
    command = ['git', '-C', workdir, 'describe',
        '--long', '--always', '--dirty', "--match='v*.*'"]
    v0 = subprocess.check_output(command).strip().decode()
    v1 = re.sub('$v', '', v0, 1)
    return re.sub('-', '.', v1, 1)


def parse_args():

    parser = argparse.ArgumentParser(
        description='build/publish Cortex Docker image')

    parser.add_argument('-n', '--namespace', metavar='NAME',
        help='Docker repository image namespace',
        required=True)

    parser.add_argument('-p', '--publish',
        default=False, action='store_true',
        help='publish after building')

    parser.add_argument('-l', '--local',
        default=False, action='store_true',
        help='publish locally (implies -p)')

    parser.add_argument('-f', '--force',
        default=False, action='store_true',
        help='overwrite if already published')

    config_default = os.path.join(
        str(pathlib.Path.home()),
        ".config", "cortex-sde", "ship.conf")

    parser.add_argument('-c', '--config', metavar='FILE',
        help='alternate config file',
        default=config_default)

    parser.add_argument('-j', '--job-id', metavar='ID',
        help='unique suffix for Docker container names',
        default=os.getpid())

    parser.add_argument('-w', '--workdir', metavar='DIR',
        help='directory with project (default: PWD)',
        default=os.getcwd())

    return parser.parse_args()
   
 
if __name__ == '__main__':
    main()
