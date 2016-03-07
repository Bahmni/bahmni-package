from setuptools import setup

setup(
    name='bahmni',
    version='0.1',
    py_modules=['bahmni'],
    install_requires=[
        'Click',
        'ansible==1.9.4'
    ],
    entry_points='''
        [console_scripts]
        bahmni=bahmni:cli
    ''',
)
