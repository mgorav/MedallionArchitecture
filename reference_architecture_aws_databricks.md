# Medallion: AWS and Databricks Integration

Medallion is a robust and integrated data architecture that leverages AWS and Databricks services to build a governed data lakehouse. It combines the strengths of both platforms to provide a comprehensive solution for data processing and analytics. Below is a complete overview of the Medallion architecture, including logical and conceptual data architecture as well as networking design.

## Logical and Conceptual Data Architecture
```mermaid
flowchart TB
  subgraph Raw_Data_Zone
    rd1[Raw Data 1] --> |Ingestion Services| S3_Raw[Amazon S3 Raw Zone]
    rd2[Raw Data 2] --> |Ingestion Services| S3_Raw
  end

  subgraph Trusted_Data_Zone
    S3_Raw --> |Orchestration Services| S3_Trusted[Amazon S3 Trusted Zone]
  end

  subgraph Refined_Data_Zone
    S3_Trusted --> |Orchestration Services| S3_Refined[Amazon S3 Refined Zone]
  end

  subgraph Delta_Lake
    S3_Refined --> |Processing Services| Delta[Delta Lake]
  end

  subgraph Unity_Catalog
    Delta --> |Processing Services| Catalog[Unity Catalog]
  end

  subgraph Databricks
    Cluster[Databricks Clusters] --> |Processing Services| Notebooks[Databricks Notebooks]
    Notebooks --> |Processing Services| Jobs[Databricks Jobs]
  end
```

### Logical Data Flow
- Raw data from various sources is ingested into the Raw Data Zone using Ingestion Services, including Kinesis Streams, Kinesis Firehose, and S3 Batch Operations.
- Orchestration Services, such as AWS Step Functions and AWS EventBridge, manage the movement of data from the Raw Zone to the Trusted Zone and then to the Refined Zone in Amazon S3.
- Data processing tasks are executed on Databricks Clusters, orchestrated by Databricks Notebooks and Jobs.
- The processed data is stored in Delta Lake and cataloged in Unity Catalog for governance and discovery.

## Networking Design
```mermaid
graph TD
  subgraph AWS
    subgraph VPC_1
      A[Private Subnet 1] --> |Private Links| S3_Raw[Amazon S3 Raw Zone]
      B[Private Subnet 2] --> |Private Links| S3_Trusted[Amazon S3 Trusted Zone]
    end

    subgraph VPC_2
      C[Private Subnet 3] --> |Private Links| S3_Refined[Amazon S3 Refined Zone]
    end
  end

  subgraph On-Premises
    OP[On-Premises Data] --> |Ingestion Services| A
    OP --> |Ingestion Services| B
  end

  subgraph Databricks_Cluster
    Cluster[Databricks Clusters] --> |Processing Services| S3_Raw
    Cluster --> |Processing Services| S3_Trusted
    Cluster --> |Processing Services| S3_Refined
  end

  subgraph Databricks_Notebooks
    Notebooks[Databricks Notebooks] --> |Processing Services| Delta[Delta Lake]
    Notebooks --> |Processing Services| Catalog[Unity Catalog]
  end
```

### Networking Details
- Private Subnet 1 and Private Subnet 2 in VPC_1 are used to securely connect to Amazon S3 Raw and Trusted Zones, respectively, using Private Links. This ensures data privacy and security.
- Private Subnet 3 in VPC_2 connects to Amazon S3 Refined Zone via Private Links for secure data transfer.
- On-Premises Data sources connect to AWS via Ingestion Services, including Kinesis Streams, Kinesis Firehose, and S3 Batch Operations.
- Databricks Clusters securely access data in S3 Raw and Trusted Zones for processing.
- Databricks Notebooks interact with Delta Lake and Unity Catalog for data development and governance.

The Medallion architecture offers a seamless and secure data processing solution, combining the scalability of AWS and the data processing capabilities of Databricks while ensuring data privacy and governance through Private Links.