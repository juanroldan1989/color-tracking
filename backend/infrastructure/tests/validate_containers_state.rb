PORT_API = attribute("port", value: "3000", description: "API port")

control "api-container" do
  impact 1.0
  title "API Container"
  desc "API container should be running"

  describe docker_container "api" do
    it { should exist }
    it { should be_running }
    its("image") { should eq "" }
    its("ports") { should eq "0.0.0.0:#{PORT_API}->3000/tcp" }
  end

  describe json({ command: "docker container inspect api"}) do
    # its([0, "HostConfig", "RestartPolicy", "Name"]) { should eq "always" }
  end
end
