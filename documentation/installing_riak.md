# Install riak

From https://ecolabardini.github.io/2016/04/17/riak-docker-strong-consistency/

```bash
git clone https://github.com/hectcastro/docker-riak.git
# Permissions may require sudo. Depends if docker is accesible
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

# Test if the cluster is working
curl -v 172.17.0.2:8098/types/strongly_consistent/buckets/test/keys/hello \
  -X PUT \
  -H "Content-type: text/plain" \
  -d "world"
curl -v 172.17.0.2:8098/types/strongly_consistent/buckets/test/keys/hello
```

```elixir
# Test strongly consistent key

iex -S mix phx.server
{:ok, pid} = Riak.Connection.start_link('172.17.0.2', 8087)
o = Riak.Object.create(type: "strongly_consistent", bucket: "test", key: "my_key_02", data: "Han Solo")
Riak.put(pid, 0)
# Find a strongly consistent key value
Riak.find(pid, {"strongly_consistent", "test"}, "hello")
# List all buckets
Riak.Bucket.list(pid)
# List all buckets in a type
Riak.Bucket.Type.list(pid, "strongly_consistent")
# List all the keys in a bucket
Riak.Bucket.keys(pid, "strongly_consistent", "test")
```

```bash
# Finally, to stop the cluster execute the following:
make stop cluster
```
