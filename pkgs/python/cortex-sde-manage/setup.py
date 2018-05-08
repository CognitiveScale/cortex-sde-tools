from setuptools import setup


setup(
    name="cortex-sde-manage",
    packages=["cortex_sde_manage"],
    entry_points={
        'console_scripts': [
            'cortex-sde-manage = cortex_sde_manage.cli:main' 
        ]
    }
)
