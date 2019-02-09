import boto3
import os

CLUSTER_NAME = os.environ['CLUSTER_NAME']
TASK_DEF_ARN = os.environ['TASK_DEF_ARN']

print ("Running task {}".format (TASK_DEF_ARN))
print ("On cluster {}".format (CLUSTER_NAME))

ecs = boto3.client ('ecs')
ec2 = boto3.client ('ec2')

def viable_subnets ():
    viable = []

    subnets = ec2.describe_subnets ()
    for subnet in subnets['Subnets']:
        viable.append (subnet['SubnetId'])
        break

    return viable


def pull_the_pin (event, context):
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

    if 'failures' in run_resp and len(run_resp['failures']) > 0:
        return run_resp['failures']
    return {'executing': TASK_DEF_ARN}