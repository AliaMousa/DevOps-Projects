This project is a practice on gcp and my mentor is Mohamed Alaa
let us speak about the project details
## Task Details
- VMs should be without public IP
- Access the Internet through NAT [NAT allows you access the internet without public ip and in the same time the traffic from internet can not reach servers or VMs]
1- Private subnet (NAT)
_________________________________
1-  Get IAM permissions
[ The Compute Network Admin role (roles/compute.networkAdmin) gives you permissions to create a NAT gateway on Cloud Router, reserve and assign NAT IP addresses, and specify subnetworks (subnets) whose traffic should use network address translation by the NAT gateway. ]

## !  ask if we need to set up NAT with dynamic port allocation ?
 note --> Each Private NAT gateway is associated with a single VPC network, region, and Cloud Router. The Private NAT gateway and the Cloud Router provide a control plane—they are not involved in the data plane, so packets do not pass through the Private NAT gateway or Cloud Router.

2- select the project 
3- enable the compute engine API and IAM Roles
  - compute Load Balancer Admin
  - compute network Admin
  - compute security Admin
  - Compute Instance Admin
4- Create a NAT subnet of purpose PRIVATE_NAT

## there are 2 methods from console and from command line
# from Console
In the Google Cloud console, go to the VPC networks page.

Go to VPC networks

To show the VPC network details page, click the name of a VPC network.

Click the Subnets tab.

Click Add subnet. In the Add a subnet dialog, do the following:

Provide a name for the subnet.
Select a region.
For Purpose, select Private NAT.
Enter an IP address range, which is the primary IPv4 range for the subnet.

If you select a range that is not an RFC 1918 address, confirm that the range doesn't conflict with an existing configuration. For more information about valid IPv4 subnet ranges, see IPv4 subnet ranges.

Note: IP address ranges that have privately used public IPv4 addresses are not supported. For more information, see VPC spokes and VPC Network Peering.
Click Add.

Creat
5- Set up Private NAT
In the Google Cloud console, go to the Cloud NAT page.

Go to Cloud NAT

Click Get started or Create Cloud NAT gateway.

Note: If this is the first Cloud NAT gateway that you're creating, click Get started. If you already have existing gateways, then instead of Get started, Google Cloud displays the Create Cloud NAT gateway button. To create another gateway, click Create Cloud NAT gateway.
Enter a gateway name.

For NAT type, select Private.

Select a VPC network for the NAT gateway.

Select the region for the NAT gateway.

Select or create a Cloud Router in the region.

Ensure that VM instances is selected as the source endpoint type.

In the Source list, select Custom.

Select a subnet on which you want to perform NAT.

If you want to specify additional ranges, click Add subnet and IP range.

Click Add a rule.

In the Rule number field, enter any value between 1 to 65000.

For Match, select either of the following options:

For Private NAT for Network Connectivity Center spokes, select Network Connectivity Center hub.
For Hybrid NAT (Preview), select Hybrid Connectivity Routes.
Select or create a private NAT subnet range.

Click Done, and then click Create.

6- Set up Private NAT with static port allocation
Private NAT uses dynamic port allocation by default. However, you can configure Private NAT to use static port allocation.

Console
gcloud
In the Google Cloud console, go to the Cloud NAT page.

Go to Cloud NAT

Click Get started or Create Cloud NAT gateway.

Note: If this is the first Cloud NAT gateway that you're creating, click Get started. If you already have existing gateways, then instead of Get started, Google Cloud displays the Create Cloud NAT gateway button. To create another gateway, click Create Cloud NAT gateway.
Enter a gateway name.

For NAT type, select Private.

Select a VPC network for the NAT gateway.

Select the region for the NAT gateway.

Select or create a Cloud Router in the region.

Specify the Cloud NAT mapping details and create a NAT rule. For more information, see Set up Private NAT.

Click Advanced configuration.

Clear Enable Dynamic Port Allocation.

Specify the value for Minimum ports per VM instance. The default is 64.

Click Done, and then click Create.

# from gcloud 
    gcloud compute networks subnets create NAT_SUBNET \
      --network=NETWORK \
      --region=REGION \
      --range=IP_RANGE \
      --purpose=PRIVATE_NAT


    gcloud compute routers create ROUTER_NAME \
      --network=NETWORK --region=REGION

    gcloud compute routers nats create NAT_CONFIG \
      --router=ROUTER_NAME --type=PRIVATE --region=REGION \
      --nat-custom-subnet-ip-ranges=SUBNETWORK:ALL|[SUBNETWORK_1:ALL ...] | \
      [--nat-all-subnet-ip-ranges]

    gcloud beta compute routers nats rules create NAT_RULE_NUMBER \
      --router=ROUTER_NAME --region=REGION \
      --nat=NAT_CONFIG \
      --match='nexthop.hub == "//networkconnectivity.googleapis.com/projects/PROJECT_ID/locations/global/hubs/HUB"' \
      --source-nat-active-ranges=NAT_SUBNET .

    gcloud beta compute routers nats rules create NAT_RULE_NUMBER \
--router=ROUTER_NAME --region=REGION \
--nat=NAT_CONFIG \
--match='nexthop.is_hybrid' \
--source-nat-active-ranges=NAT_SUBNET ...

      gcloud compute routers nats create NAT_CONFIG \
    --router=ROUTER_NAME --type=PRIVATE --region=REGION \
    --nat-custom-subnet-ip-ranges=SUBNETWORK:ALL|[SUBNETWORK_1:ALL,SUBNETWORK_2:ALL,...] \
    --no-enable-dynamic-port-allocation \
    [--min-ports-per-vm=VALUE]


# Authenticate to Google Cloud
$ gcloud auth application-default login

# Terraform Part
$ terraform init
$ terraform plan
$ terraform apply




## Questions
# 1- Should I create private network before I start of should i use the default one?
# 2- Should I use Terrafrom to creaete the cloud NAT and the Network or What?
# 3- The NAT should be private or public
# 4- For the NAT IP address should I use static IP or dynamic one