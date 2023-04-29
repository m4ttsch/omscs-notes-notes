---
id: databases-efficiency-indexing-physical-design
title: Efficiency, Indexing, and Physical Database Design
course: databases
lecture: efficiency-indexing-physical-design
---

# Efficiency, Indexing, and Physical Database Design

## Efficiency, Indexing, Physical Database Design

The physical database design and the resulting efficiency are critical when
building database applications. We may have done an outstanding job designing
and implementing the database itself and the applications that run on top of it,
but if they are too slow to be useful, then it doesn't matter. Let's look at
some tools we have to physically design the database, organize the data, index
it, and get to it quickly.

## Computer Architecture

There are two kinds of storage, or memory, in a computer. The bulk of data and
applications are stored in secondary storage, which is usually a physical
**disk**. **Random access memory** (RAM), also known as main memory, stores the
currently running programs and their data. Applications run by the CPU can only
query and update data stored in main memory. A **bus** allows us to transport
data between disk and main memory.

Main memory is volatile and expensive, needing constant power to maintain its
state. Relative to secondary memory, main memory can hold much less data and is
faster to access. Secondary memory is permanent storage that is cheaper to
maintain since it does not need power to keep its state. Relative to main
memory, it can hold much more data and is slower to access.

Only a tiny fraction of a real database will fit in main memory. As a result, we
must have auxiliary programs, such as buffer management programs, that enable us
to transport data between main and secondary memory. People who talk about main
memory databases are not talking about databases. They are talking about toys.
Going forward, we will assume that the vast majority of the database will be
stored on disk and only a tiny fraction will be in main memory at any given
point in time.

## Why Should You Care

Let's briefly discuss why we should care about how long it takes to access data
in main memory and on disk. Main memory access typically takes thirty
nanoseconds, or $3 \times 10^{-7}$ seconds. In comparison, disk access takes ten
milliseconds, or $1 \times 10^{-2}$ seconds. In other words, we can perform $3
\times 10^5$ main memory accesses for every disk access. This difference is so
significant that we actually ignore main memory access time when performing cost
computations and only count disk access time, also known as the I/O cost.

## Main Memory vs. Disk

Let's use a phone book as a metaphor to illustrate the difference between main
memory access and disk access. We can think about main memory access as
processing the currently open phone book page. Assume that it takes one minute
to complete. Disk access, on the other hand, corresponds to flipping the phone
book to the next page available for processing. How long would that take? Given
that the difference between main memory access and disk access is five orders of
magnitude, it would take two hundred days to open the book to the next page.
Once that page is open, we can read it in one minute.

## Disk

To understand how data resides in secondary storage, let's first understand the
structure of a disk. A disk consists of several circular plates known as
**platters**, which all sit on the same **spindle** and rotate together.
**Read-write heads** access the top and bottom of each platter, and an
**actuator** connects all the read-write heads and moves them together in a
synchronized fashion, rotating to move them closer to or further from the center
of the platter. On each platter surface, what passes under the read-write head
in that position is called a **track**. Each platter, therefore, exposes two
tracks. The collection of tracks passing under the read-write heads is known as
a **cylinder**.

Each platter surface is split into **sectors**. A sector is the smallest
physical data unit, 512 bytes, that can be transported from disk to main memory.
A **block** comprises multiple sectors and, depending on what type of data we
need to store on disk, typically contains 4kB, 8kB, or 16kB of data,
corresponding to 8, 16, or 32 sectors, respectively. Typically, blocks, not
sectors, are the unit of information transferred between the disk and main
memory.

A higher-end disk pack might have four platters with eight read-write heads.
This disk pack might have a 600MB/s transfer rate, running at 10,000 RPMs, with
a latency between three and four milliseconds. It could have 150,000 tracks per
surface, with 1000kB per track and a total disk capacity of 1200GB. Most systems
have a default block size of 4kB, but some major systems default to 8kB.

## Records

Let's now look at how we store records on a block on a disk. First, how do we
determine the size of a record? Consider the `RegularUser` relation, which has
`Email`, `Sex`, `BirthDate`, `CurrentCity`, and `Hometown` attributes. We
previously defined the `Email`, `CurrentCity`, and `Hometown` attributes as type
`varchar(50)`. `Sex` fits into a single character, occupying one byte, and the
`datetime` type used for `BirthDate` occupies eight bytes.

Adding these numbers together, we get a record size of 159 bytes. Let's lay this
out in a block:

- `Email` occupies bytes one through fifty
- `Sex` occupies byte fifty-one
- `BirthDate` occupies bytes fifty-two through fifty-nine.
- `CurrentCity` occupies bytes sixty through 109
- `Hometown` occupies bytes 110 through 159

At byte 160, we are ready to write the `Email` of the next record.

## Blocks

It is possible to store several records on a single block. Let's assume that the
block size is 4kb and that we have the full space available. In reality, this is
not true, as the system will reserve some space for metadata about data formats
and next pointers, but we can ignore that for now.

Typically we only run with blocks partially full, so let's also assume that we
only fill blocks to 80% capacity. We might not want to completely fill a block
with data because overflowing a block on an insert attempt comes with extra
processing overhead. 80% of 4kB is 3200 bytes, and with a record size of 159
bytes, we can fit about twenty records per block with a little extra space to
spare.

There are two ways of thinking about what happens to the space at the end of a
block that can't fit a complete record. In a **spanned representation**, we fill
the block with as much data as possible, splitting the record across multiple
blocks if needed. In an **unspanned representation**, we ignore the tiny amount
of wasted space at the end of the block and place the entire record on a new
block instead.

Typically, if multiple records will fit on a block, most database systems run
with unspanned representation simply to avoid the processing overhead necessary
to break up records. Of course, if we have record sizes larger than block sizes,
we don't have a choice; in those instances, we must use a spanned
representation.

## Files

Files consist of multiple blocks connected by address pointers. The blocks may
not physically sit next to each other on disk, but we can traverse them via
these pointers. Within a 32-bit computer architecture, we can assume that block
pointers occupy four bytes.

Suppose we have four million `RegularUser` records. If we know that we can fit
twenty records in a block, then we need 200,000 blocks (four million divided by
twenty). With a block size of 4kB, our resulting file size is 800MB.

## Assumptions

To compute the time it takes to transport data from disk to main memory, let's
make some assumptions about how long certain operations take:

- Seek times typically take 3-8ms
- Rotational delays typically take 2-3ms
- Transfer times take 0.5-1ms

Adding these values gives us a range of 5-12ms, so let's conservatively say that
a particular [page fault](https://en.wikipedia.org/wiki/Page_fault) takes 10ms.

We can avoid paying multiple seek and rotational costs by collecting multiple
blocks of data in a single page fault. This strategy intuitively makes sense: if
we need one block of data for our application, it stands to reason that we may
need some adjacent blocks as well. Bulk transfers or **extent transfers** move a
large number of blocks - say, 250 - in one shot without paying additional seek
time and rotational delay. Once we have found the first block in the collection,
we only incur transfer time costs for the remaining blocks.

Indeed, the savings are significant. Transferring 250 blocks individually at
10ms per block takes 2.5 seconds. Let's consider the savings in seeking time and
rotational delay. Transferring 250 blocks in an extent transfer takes 260 ms:
250 transfers at 1 ms plus one seek time and one rotational delay of 10 ms.

One of the problems with bulk transfers is that we will need more buffer space
to hold the extra data. In timeshare systems, a favorite buffer management
strategy is the **least recently used** (LRU) strategy. The idea is that when we
run out of buffer space and need to free up space for the new data coming in
from disk to main memory, we overwrite what has been least recently used. The
philosophy here is that the least recently used data is also the least likely to
be needed next.

It is not always the case that the LRU strategy works well from the point of
view of a database management system. It is excellent for merge joins where two
relations are sorted on the join fields, and we merge them on matching keys.
However, LRU strategies are very inefficient for nested loop joins. In that
case, we might instead use a [most recently
used](https://en.wikipedia.org/wiki/Cache_replacement_policies#Most_recently_used_(MRU))
(MRU) strategy.

## Heap Unsorted

The first disk organization strategy we will examine is a **heap**, which is an
unsorted data file. When we search for a record in a heap, we have no way of
knowing on which block that record may sit, so we must scan the data pages to
find the record. Sometimes, we are lucky, and the data we need sits on the first
block. Other times, it sits on the last block. Given a file of $N$ data blocks,
we can expect to examine $N/2$ data blocks on average. With four million records
spanning 200000 data blocks, $N/2$ equals 100000 blocks. If each data block
takes 10 ms to bring into memory, then searching for a record in this heap will
take 16.6 minutes on average.

## Sorted File

Searching for data in a heap is a slow process. Let's sort the data in the file
and see how that improves lookup time. Even with sorted data, we can still use
our naive strategy of searching block by block. Again, sometimes the record we
are looking for will be on the first block. Sometimes it will be on the last
block. On average, as for unsorted data, this strategy requires us to look at
about half of the blocks of data, which we already calculated will take 16.6
minutes on average.

Now let's leverage the fact that we have sorted data. What if we had some
metadata that would allow us to find the approximate middle block in a data
file? We could look at that middle block and then determine whether what we are
searching for is to the left or the right of that block. Repeating this process,
we can divide the search space in two on each iteration. This process is called
**binary search** and only works with sorted data.

The amount of time it takes to perform a binary search through $N$ blocks is on
the order of $\log_2(N)$. After $\log_2(N)$ accesses, we will end up with a
single block containing the data element of interest if the element is in the
database. Given 200000 data blocks corresponding to four million records, we
have to perform $\log_2(200,000) = 18$ block accesses. Since each block access
takes 10 ms, the binary search takes 0.18s. This search is much more efficient
than the linear search, which took about 5500 times longer.

For both search algorithms - binary and linear search - remember that the search
cost depends on the size of the search space, the number of blocks, $N$, in the
case. Since linear search scales linearly with $N$, and binary search scales
logarithmically, binary search is the more efficient algorithm for any
meaningful $N$.

## Primary Index: Part 1

In addition to sorting the data and leveraging that ordering when we search, we
might want to consider ways of reducing the search space itself. Indices help us
accomplish this reduction.

Let's remember the structure of our data file. We have records sorted by key
values laid out in blocks. To build a **sparse primary index**, we iterate
through the data blocks and append the key value of the first record in the
block and a pointer to that block to the current index block. Since we are
picking up the key values in sorted order, the index is in sorted order by
default.

Since the index blocks only contain key values and block pointers, we can
reference many data blocks from a single index block. The ratio of index blocks
to data blocks is called **fanout**. What's the fanout in this case? We know
that a block is 4kB and that we only fill blocks to 80% capacity, so we have
3.2kB available. The primary key, `Email`, is fifty bytes long, and block
pointers occupy four bytes, so we need fifty-four bytes per index entry.
Dividing 3.2kB by fifty-four bytes gives us about sixty index entries per block.
So, the fanout here is sixty.

## Primary Index Part: 2

Given a fanout of sixty, how many index blocks do we need? If we start with
200,000 data blocks and can point to sixty data blocks per index block, then we
need 200,000 divided by sixty index blocks, equaling 3,334 index blocks.

Instead of building a sparse index, we could have built a dense index. To build
a **dense primary index**, we iterate through the data blocks and append the key
value of _each_ record in the block and a pointer to that block to the current
index block. Again, since we are picking up the key values in sorted order, the
index is in sorted order by default.

The fanout is still sixty, but, in this case, we have one index entry per record
instead of one entry per data block. If we divide four million records by sixty
index entries per index block, we need 66,666 index blocks to index every key.

One advantage of maintaining a dense index is that the system can answer some
queries solely by examining the index without ever having to touch the data
blocks. For example, we can use the index to find the maximum and minimum key
values. Additionally, we can use dense indices for range queries, such as
finding all emails that start with a particular letter.

Let's take a look at some lookup times. Whereas previously, we used $N$ to
indicate the number of data blocks, let's use $n$ to indicate the number of
index blocks. The cost of performing a binary search in the index is
$\log_2(n)$. Once we identify the data block containing the record of interest,
we still have to access that data block, so the total cost is $\log_2(n) + 1$.

For the sparse index containing 3,334 index blocks, we need to perform
$\log_2(3,334) + 1 = 13$ lookups. At 10 ms per lookup, this search takes 0.13
seconds. Notice that this value is lower than the 0.18 seconds we needed to
perform a binary search directly on the data blocks.

The dense index is larger, so we can expect the cost to be higher. With 66,666
index blocks, we need to perform $\log_2(66,666) + 1 = 17$ lookups. At 10 ms per
lookup, this search takes 0.17 seconds. While this value is greater than the
lookup time associated with the sparse index, it's still lower than the 0.18
seconds we needed to search without an index.

Remember that we are only talking about lookup costs here. If we need to perform
any updates, the total cost includes the lookup cost and the cost to write data
back to disk after it has been changed. In simple situations, we typically add
an extra disk access cost for each write. Note that changes that affect the
index incur additional access costs.

## Secondary Index

We build **secondary indices** when we need to index records on some non-key
value. We follow the same process when building a secondary index as when
building a dense index, iterating through the data blocks and appending to the
current index block the attribute value of _each_ record in the block and a
pointer to that block.

When we examine a newly created secondary index, we see that the attribute
values are unsorted. Remember that the original data file is sorted by key
values but is unsorted for all non-key attribute values. To leverage binary
search, we must sort the secondary index after creating it. Since the ordering
of attribute values in the index does not match the ordering in the data file,
all secondary indices must be dense. A similar consequence of this mismatch is
that while dense indices are normally well-suited for range queries, secondary
indices are only suited for point queries, despite being dense.

The cost to perform a binary search in the secondary index is still $\log_2(n)$,
where $n$ is the number of index blocks. With 66,666 index blocks, we need to
perform $\log_2(66,666) + 1 = 17$ lookups. At 10 ms per lookup, this search
takes 0.17 seconds. While this value is greater than the lookup time associated
with the sparse index, it's still lower than the 0.18 seconds we needed to
search without an index.

Notice that we implicitly made the simplifying assumption that the attribute
from which we build the index has no duplicate values. If values for this
attribute are not unique, we must consider how to associate these values with a
collection of block pointers locating the matching records. Of course, we are
allowed to make this assumption when building primary indices because keys must
be unique.

## Multilevel Index

We have seen several good ideas so far for increasing how efficiently we find
records of interest. For example, we saw that sorting our data and then
leveraging that ordering when searching improves search times. Additionally, we
saw that reducing the size of the search space by building indices is a smart
way to locate data quickly.

If one index improves efficiency, then why don't we index the index and index
that index too? We can repeat this process until we have an index that fits
entirely on one block, allowing us to read the whole index into memory by paying
just one access cost.

Searching through this **multilevel index** works as follows. We pull the
top-level index block into memory. Among the sixty key values in that block, we
find the value equal to or just less than the one we are seeking. We follow the
corresponding block pointer to the index block in the next level of the tree and
repeat this process, traversing down the tree until we hit a leaf node. This
leaf node is the data block where the record of interest resides.

Searching for data using multilevel indices is still logarithmic in $n$.
However, the base is not two but rather is equal to the fanout. The consequence
of changing the base means we no longer divide the search space by two on each
iteration but rather by the fanout. Given 3,334 sparse index blocks, with a
fanout of sixty, we need to perform $\log_{60}(3,334) + 1 = 3$ accesses to pull
the record of interest into memory. At 10 ms per access, we only need 0.03
seconds. Contrast this with the thirteen lookups (and 0.13 seconds) we needed to
perform a binary search on the sparse index.

The more indices we place on top of a primary index, the more sensitive we are
to overflow effects. Suppose we insert a new record at the data level, and the
record overflows its block. We now need to split this block into two to
accommodate the additional data. The question is: will this split impact the
first level index, and if it does, how far up the tree will the impact
propagate? It's important to keep the ripple effect small, as updating the tree
comes with a cost, and that's exactly why we don't fill blocks to 100% capacity.

## Multilevel Index: B+ Tree

The most popular implementation for multilevel indices, found in many relational
database products, is a data structure known as a **B+ tree**. In a B+ tree, all
the data resides in the leaf nodes, and all other nodes are index nodes. A B+
tree remains balanced after insertion, deletion, and update operations; the
distance from the root to the leaves remains roughly the same for all leaves
over time. Balance is critical since the search performance quickly degrades if
the tree becomes unbalanced. Another feature of a B+ tree is that it is rare
that an overflow at a lower level will propagate up the tree more than one or
two levels, if at all.

## Static Hashing: Part 1

Let's look at a completely different approach to primary data organization
called static hashing. In **static hashing**, we map key values from a key space
into buckets using a **hash function**, `h`. Given `M` buckets, `h` can map key
values to buckets 0 through `M-1`. For example, `h` might map the key
"user1@gt.edu" to bucket 103. Associated with that bucket may be a block
address, and records whose keys map to that bucket will be written to the block
at that address.

A good hash function has the following characteristics. First, it must
distribute the values in the key value space uniformly over the buckets. On a
related note, it's also important that a hash function avoids collisions.
**Collisions** occur when distinct keys are mapped to the same bucket too many
times. A good hash function should also fill the buckets as much as possible.
The bucket directory can be large enough that a portion may be stored on disk
and, therefore, be subject to being ported between disk and memory. A full
directory ensures we can transport the maximum amount of data on each transfer.

## Static Hashing: Part 2

Before we insert any records, we have an empty bucket directory and a hash
function, `h`. Associated with each bucket number is some space to hold a block
address. When we insert a new record, we hash its key with `h` to get the bucket
number, locate or allocate the data block associated with that bucket, and then
write the record to that block. Remember that several records may fit on each
block, so we might not need to allocate a new block for every record we insert.

If a data block is full, and a new record's key hashes to the bucket entry
associated with that data block, we must allocate a new data block to continue
to store records associated with that bucket. The pointer to that data block
will reside at the end of the just-filled data block.

Once we have inserted all the data and built the hash table, we want to use it
to find a record with a particular key value. We input the key value to the hash
function and receive the bucket entry as output. Next, we look up the block
address associated with that bucket in the directory, and then we access that
block to retrieve the record if it is in the database.

It takes one block access to bring the bucket directory page we need into
memory, followed by one block access to bring the data block associated with the
bucket into memory. With an access cost of 10 ms, the total cost for these two
accesses is 20 ms. The bucket directory may be small enough to partially or
fully stay in memory. If that's the case, accessing a record requires one block
access at 10ms.

All the different lookup times we have seen thus far have depended on the data
or index size. What's excellent about static hashing is that it provides
constant time data access. Beware, though, as we insert more data into a
fixed-size bucket directory, we will build increasingly longer chains of data
blocks. The records in these blocks are unordered, so as these chains become
longer, the search begins to resemble a slow linear heap search. Thankfully,
dynamic hash functions that allow the address space to expand to keep the data
access cost constant exist.

Also, remember that an important job of the hash function is to allocate the
records we insert across the buckets uniformly. Even with an appropriately large
bucket directory, a nonuniform hash function will create some chains of data
blocks that are much longer than others, which degrades the search performance.
