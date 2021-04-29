// `src/` shall be included into Jsonnet library path
local useCustomSourceImage = import 'custom-source-image.libsonnet';
local acmejobtmpl = import 'letsencrypt-job-template.jsonnet';
local nc = import 'node-configurator.jsonnet';
local obstmpl = import 'observer-template.jsonnet';
local usePrebuiltImage = import 'prebuilt-image.libsonnet';
local regjobtmpl = import 'registry-job-template.jsonnet';
local regtmpl = import 'registry-template.jsonnet';

// the following files will be generated by `jsonnet -J src -m . main.jsonnet`
function(version) {
  'lib/metadata.json': { version: version },

  local observerTemplate = obstmpl { version: version },
  'observer/ocp-template.json': observerTemplate,
  'observer/ocp-custom-source-image-template.json': useCustomSourceImage(
    observerTemplate,
    version,
  ),
  'observer/ocp-prebuilt-image-template.json': usePrebuiltImage(
    observerTemplate,
    version,
  ),

  local registryTemplate = regtmpl { version: version },
  'registry/ocp-template.json': registryTemplate,
  'registry/ocp-custom-source-image-template.json': useCustomSourceImage(
    registryTemplate,
    version,
  ),


  local registryJobTemplate = regjobtmpl { version: version },
  'registry/deploy-job-template.json': registryJobTemplate,
  'registry/deploy-job-custom-source-image-template.json': useCustomSourceImage(
    registryJobTemplate,
    version,
  ),

  local acmeJobTemplate = acmejobtmpl { version: version },
  'letsencrypt/deploy-job-template.json': acmeJobTemplate,
  'letsencrypt/deploy-job-custom-source-image-template.json': useCustomSourceImage(
    acmeJobTemplate,
    version,
  ),

  local nodeConfigurator = nc { version: version },
  'node-configurator/is.json': nodeConfigurator.ImageStream,
  'node-configurator/sa.json': nodeConfigurator.ServiceAccount,
  'node-configurator/daemonset.json': nodeConfigurator.DaemonSet,
  'node-configurator/all.json': nodeConfigurator.List,
  'node-configurator/ocp-template.json': nodeConfigurator.Template,
}
