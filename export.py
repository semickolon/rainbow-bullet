#!/usr/bin/python
from string import Template
import argparse
import sys
import re
import subprocess
import shutil
import os

PLATFORMS = ['windows', 'osx', 'linux', 'web']
INCLUDE_UNIVERSAL = []
EXCLUDE_UNIVERSAL = [
    'addons/godot-git-plugin/' # We don't need this in builds
    # Though the Git plugin libs still get exported due to an issue: https://github.com/godotengine/godot-git-plugin/issues/77
    # A workaround is done below wherein a temporary .gdignore file is created during export
]
GODOT_VERSION = '3.4.4'

EXPORT_PRESETS_PATH = 'export_presets.cfg'
EXPORT_PRESETS_BAK_PATH = 'export_presets.cfg.bak'

IGNORE_DIRS_TEMPORARILY = [ 'addons/godot-git-plugin' ]
IGNORE_FILENAME = '.gdignore'

def validate():
    godot_exists = shutil.which('godot') is not None
    if not godot_exists:
        print('ERROR: `godot` is not a command or an executable')
        return False

    version = get_command_output('godot --version')
    if not version.startswith(GODOT_VERSION):
        print('ERROR: Incorrect Godot version. Must be {}'.format(GODOT_VERSION))
        return False

    return True

def exec_command(cmd):
    return os.system(cmd) == 0

def get_command_output(cmd):
    try:
        return subprocess.check_output(cmd.split(' '))
    except subprocess.CalledProcessError as e:
        return e.output.decode()

def identify_version():
    with open('project.godot', 'r') as f:
        contents = f.read()
        match = re.search('config/version="(.+)"', contents)

        if match is not None:
            return match.group(1)

    print('WARNING: Version not found in project.godot')
    return '(Unknown version)'

def make_export_presets(version, include_filters, exclude_filters):
    if not os.path.isfile(EXPORT_PRESETS_PATH):
        print('ERROR: Export presets file not found')
        return False

    try:
        shutil.copyfile(EXPORT_PRESETS_PATH, EXPORT_PRESETS_BAK_PATH)

        with open(EXPORT_PRESETS_PATH, 'r+') as f:
            t = Template(f.read())
            new_contents = t.substitute({
                'VERSION': version,
                'INCLUDE_FILTERS': include_filters,
                'EXCLUDE_FILTERS': exclude_filters
            })

            f.write(new_contents)
    
        return True
    except Exception as e:
        print(e)
        print('ERROR: An exception has occured while making export presets')
        return False

def revert_export_presets():
    if not os.path.isfile(EXPORT_PRESETS_BAK_PATH):
        return

    try:
        if os.path.isfile(EXPORT_PRESETS_PATH):
            os.remove(EXPORT_PRESETS_PATH)
        
        os.rename(EXPORT_PRESETS_BAK_PATH, EXPORT_PRESETS_PATH)
    except Exception as e:
        print(e)
        print('WARNING: An exception has occured while reverting export presets to original')

def get_ignore_file_path(dir):
    return '{}/{}'.format(dir, IGNORE_FILENAME)

def ignore_dirs_temp():
    try:
        for dir in IGNORE_DIRS_TEMPORARILY:
            if not os.path.isdir(dir):
                continue

            file_path = get_ignore_file_path(dir)

            with open(file_path, 'w') as f:
                f.write('')
    except Exception as e:
        print(e)
        print('WARNING: An exception has occured while creating Godot ignore files')

def undo_ignore_dirs_temp():
    try: 
        for dir in IGNORE_DIRS_TEMPORARILY:
            file_path = get_ignore_file_path(dir)
            if os.path.isfile(file_path):
                os.remove(file_path)
    except Exception as e:
        print(e)
        print('WARNING: An exception has occured while removing Godot ignore files')

def export():
    parser = argparse.ArgumentParser('export')
    parser.add_argument('platform', help='Platform', choices=PLATFORMS)

    args = parser.parse_args()
    platform = args.platform
    version = identify_version()

    print('Starting export...')
    print('Version: {}, Platform: {}'.format(version, platform))
    print('-' * 10)

    include_filters = ','.join(INCLUDE_UNIVERSAL)
    exclude_filters = ','.join(EXCLUDE_UNIVERSAL)

    steps = [
        {
            'func': lambda : make_export_presets(version, include_filters, exclude_filters),
            'start_message': 'Making export presets...',
            'error_message': 'ERROR: Failed to make export presets'
        },
        {
            'func': lambda : os.makedirs('bin/' + platform, exist_ok=True),
            'start_message': 'Making export dirs...',
            'error_message': 'ERROR: Failed to make export dirs'
        },
        {
            'func': lambda : exec_command('godot --no-window --export {}'.format(platform)),
            'start_message': 'Exporting with Godot...',
            'error_message': 'ERROR: Godot export failed'
        }
    ]

    ignore_dirs_temp()
    
    def clean():
        revert_export_presets()
        undo_ignore_dirs_temp()

    for step in steps:
        print(step['start_message'])
        success = step['func']()

        if success == False:
            print(step['error_message'])
            clean()
            return False

    clean()
    return True

if __name__ == '__main__':
    if not validate():
        print('ERROR: Validation failed')
        sys.exit(1)
    elif not export():
        print('ERROR: Export failed')
        sys.exit(1)
    else:
        print('Export success!')
