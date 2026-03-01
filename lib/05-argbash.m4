# Argbash template for karavomarangos argument parsing.
# Generate with: argbash lib/05-argbash.m4 -o lib/05-argbash.sh --strip user-content
#
# ARG_OPTIONAL_SINGLE([json-file], [], [Path to the JSON image definition file], [])
# ARG_OPTIONAL_BOOLEAN([update-packages], [], [Update package versions in the JSON file], [on])
# ARG_OPTIONAL_BOOLEAN([update-dockerfile], [], [Generate/update the Dockerfile], [on])
# ARG_OPTIONAL_SINGLE([dockerfile-output], [], [Path where to render the Dockerfile], [Dockerfile])
# ARG_OPTIONAL_BOOLEAN([update-readme], [], [Update the image README], [on])
# ARG_OPTIONAL_SINGLE([readme-output], [], [Path where to render the README (not yet supported)], [README.md])
# ARG_HELP([Karavomarangos — manage Limani Docker image definitions])
# ARGBASH_GO
