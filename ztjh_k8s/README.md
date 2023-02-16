# JupyterHub for Spatial Data Science

## Goal

[JupyterHub](https://z2jh.jupyter.org/en/stable/index.html) allows users to interact with a computing environment through a webpage. As most devices have access to a web browser, JupyterHub makes it is easy to provide and standardize the computing environment for a group of people (e.g., for a class of students or an analytics team).

Our goal is to configure a MicroK8s JupyterHub deployment for on-prem hardware. One NIC for management, and another (high throughput NIC) for JupyterHub to both serve the labs as well as access the file server.

## Next Steps

<https://z2jh.jupyter.org/en/stable/jupyterhub/customizing/user-environment.html>

- configure multiple existing docker image options
- configure simple auth
- build custom spatial data docker image
- configure https? (possible?)
- configure remote access?

happy hacking :)
