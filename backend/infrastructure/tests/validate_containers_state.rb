PORT_DB = attribute("port", value: "5432", description: "DB port")
PORT_ZOO = attribute("port", value: "2181", description: "ZOOKEEPER port")
PORT_KAFKA = attribute("port", value: "9092", description: "KAFKA port")
PORT_API = attribute("port", value: "3000", description: "API port")
PORT_KARAFKA = attribute("port", value: "3001", description: "KARAFKA port")

control "db-container" do
  impact 1.0
  title "DB Container"
  desc "DB container should be running"

  describe docker_container "db" do
    it { should exist }
    it { should be_running }
    its("image") { should eq "postgres:9.6-alpine" }
    its("ports") { should eq "0.0.0.0:#{PORT_DB}->#{PORT_DB}/tcp" }
  end

  describe json({ command: "docker container inspect db" }) do
    its([0, "HostConfig", "NetworkMode"]) { should include "color-tracking-net" }
  end
end

control "zoopkeeper-container" do
  impact 1.0
  title "Zookeeper Container"
  desc "Zookeeper container should be running"

  describe docker_container "zookeeper" do
    it { should exist }
    it { should be_running }
    its("image") { should eq "wurstmeister/zookeeper" }
    its("ports") { should eq "22/tcp, 2888/tcp, 3888/tcp, 0.0.0.0:#{PORT_ZOO}->#{PORT_ZOO}/tcp" }
  end

  describe json({ command: "docker container inspect zookeeper" }) do
    its([0, "HostConfig", "NetworkMode"]) { should include "color-tracking-net" }
  end
end

control "kafka-container" do
  impact 1.0
  title "Kafka Container"
  desc "Kafka container should be running"

  describe docker_container "kafka" do
    it { should exist }
    it { should be_running }
    its("image") { should eq "wurstmeister/kafka" }
    its("ports") { should eq "0.0.0.0:#{PORT_KAFKA}->#{PORT_KAFKA}/tcp" }
  end

  describe json({ command: "docker container inspect kafka" }) do
    its([0, "HostConfig", "NetworkMode"]) { should include "color-tracking-net" }
  end
end

control "api-container" do
  impact 1.0
  title "API Container"
  desc "API container should be running"

  describe docker_container "api" do
    it { should exist }
    it { should be_running }
    its("image") { should eq "juanroldan1989/color-tracking-api" }
    its("ports") { should eq "0.0.0.0:#{PORT_API}->#{PORT_API}/tcp" }
  end

  describe json({ command: "docker container inspect api" }) do
    its([0, "HostConfig", "NetworkMode"]) { should include "color-tracking-net" }
  end
end

control "karafka-consumer-container" do
  impact 1.0
  title "Karafka Consumer Container"
  desc "Karafka Consumer container should be running"

  describe docker_container "karafka-consumer" do
    it { should exist }
    it { should be_running }
    its("image") { should eq "juanroldan1989/color-tracking-api" }
    its("ports") { should eq "0.0.0.0:#{PORT_KARAFKA}->3000/tcp" }
  end

  describe json({ command: "docker container inspect karafka-consumer" }) do
    its([0, "HostConfig", "NetworkMode"]) { should include "color-tracking-net" }
  end
end
