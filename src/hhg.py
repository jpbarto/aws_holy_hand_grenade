import boto3
import os

CLUSTER_NAME = os.environ['CLUSTER_NAME']
TASK_DEF_ARN = os.environ['TASK_DEF_ARN']

ecs = boto3.client ('ecs')
ec2 = boto3.client ('ec2')

def viable_subnets ():
    viable = []

    subnets = ec2.describe_subnets ()
    for subnet in subnets['Subnets']:
        if 'MapPublicIpOnLaunch' in subnet and subnet['MapPublicIpOnLaunch']:
            viable.append (subnet['SubnetId'])
            break

    return viable


def throw_grenade (event, context):
    subnets = viable_subnets ()

    run_resp = ecs.run_task (
        cluster = CLUSTER_NAME,
        taskDefinition = TASK_DEF_ARN,
        launchType = 'FARGATE',
        networkConfiguration = {
            'awsvpcConfiguration': {
                'subnets': subnets
            }
        }
    )

    return run_resp