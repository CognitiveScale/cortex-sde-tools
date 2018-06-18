from setuptools import setup


setup(
    name="cortex-sde-ship",
    packages=["cortex_sde_ship"],
    entry_points={
        'console_scripts': [
            'cortex-sde-ship = cortex_sde_ship.cli:main' 
        ]
    }
)
