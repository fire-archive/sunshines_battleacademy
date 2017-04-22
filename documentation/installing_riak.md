# Install riak

From https://ecolabardini.github.io/2016/04/17/riak-docker-strong-consistency/

```bash
git clone https://github.com/hectcastro/docker-riak.git
cd docker-riak && make build
# Running a 5 node cluster with strong consistency enabled:
export DOCKER_HOST="unix:///var/run/docker.sock"
DOCKER_RIAK_AUTOMATIC_CLUSTERING=1 DOCKER_RIAK_CLUSTER_SIZE=5 DOCKER_RIAK_STRONG_CONSISTENCY=on make start-cluster
# You can get the nodes IP addresses with the following command:
make test-cluster | egrep -A6 "ring_members"
# Connect to a Riak Docker instance to create a strongly consistent bucket type:
docker exec -it riak01 bash
riak-admin bucket-type create strongly_consistent \ 
  '{"props":{"consistent":true}}'
riak-admin bucket-type activate strongly_consistent
# Finally, to stop the cluster execute the following:
make stop cluster
```
