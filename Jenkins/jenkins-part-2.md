# Selective & Declarative pipelines

1. In the previous part, we have run the jobs in different slaves with LABEL as identifiers. Those jobs are called free-style jobs. But in real time we won't run freestyle jobs much except for small task. We use pipelines to run jobs. To do that we need to install plugins in jenkins.

2. Go to Dashboard --> Manage Jenkins --> Plugins --> search for `aws steps`, `blue ocean` and install both without restart.
