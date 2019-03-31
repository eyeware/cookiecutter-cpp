"""Post-project generation hooks"""

if __name__ == '__main__':
    """Initialize a git repository based on the configured branch and repo"""
    url    = 'git@{{ cookiecutter.git_server }}:{{ cookiecutter.username }}/{{ cookiecutter.project_slug }}.git'
    branch = '{{ cookiecutter.branch }}'
    remote = '{{ cookiecutter.remote }}'

    import subprocess
    subprocess.call(('git', 'init'))
    subprocess.call(('git', 'checkout', '-b', branch))
    subprocess.call(('git', 'remote', 'add', remote, url))
#TODO: #11    subprocess.call(('mv', 'pre-commit', '.git/hooks/'))
