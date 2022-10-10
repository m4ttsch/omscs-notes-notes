---
id: databases-methodology-one-analysis
title: "Methodology I: Analysis"
course: databases
lecture: methodology-one-analysis
---

# Methodology I: Analysis

## Database Application Development Methodology - Assumptions

The database application development methodology we will learn was designed
exclusively for database-supported applications. This methodology will not work
for general software development projects.

We make certain assumptions when working with this methodology. For example, we
assume that the underlying business processes are well-designed and all
documents, tasks, and system boundaries are known. Furthermore, we assume that
one database schema unifying all views can be designed. All of these assumptions
must hold for the methodology to be successful.

**Documents** are anything input to or output from the applications that run on
the database. **Tasks** represent the functional units that operate on
documents, reading from and writing to the database where appropriate.

Creating a unified database schema is challenging, as different groups of
individuals in an organization have competing interests and goals. This
difficulty is not a fault of the methodology but rather a fault of the
organization.

## The Software Process

As we know from our software engineering courses, a waterfall software process
typically consists of the following phases:

- Business process design
- Analysis
- Specification
- Design
- Implementation
- Testing
- Operation
- Maintenance

We need all of these phases when developing database applications as well. The
analysis, specification, design, and implementation phases of database
application development diverge the most from the general software development
paradigm, and we will focus on those four phases exclusively.

## Overview of Methodology: Data First

In general software development methodologies, one often focuses on
functionality first. There is an emphasis on organizing class diagrams to ensure
correct behavior and perhaps less focus on the data needed to support that
behavior. In database development, we first focus on data and only hang the
processes where they fit after defining the data.

As we said previously, the four phases of database application development we
will examine are:

- Analysis
- Specification
- Design
- Implementation

![The four steps involved in the database application development
methodology.](https://assets.omscs.io/notes/20220920165324.png)

Before we begin the analysis phase, we must gather requirements from the
customer. Without this information, we can still proceed with database
application development, but it's unlikely that the customer will find the end
product valuable. Once we have gathered requirements, we use them in the
analysis phase to create an **information flow diagram** (IFD).

We use the IFD in the specification phase to create an entity-relationship or
extended entity-relationship diagram modeling that data. Next, we use that model
to develop a specification of the tasks or applications that need to run on the
database represented by the data model.

In the design phase, we translate our data model into a relational database
schema. Then we write SQL queries against that schema and additional abstract
code to formalize the tasks we defined in the specification phase.

Finally, in the implementation step, we use a specific database implementation,
such as MySQL, to create the relational database defined by our schema. We then
transform the abstract code and queries into executable code using a programming
language - PHP with embedded SQL, for example - to build the final functional
product.

## GTOnline Networking Application

We will now begin our walk-through of the four phases of the database
application development methodology. Of course, we don't have a real customer,
but we can pretend that
[this](https://static.us.edusercontent.com/files/sCXHBBBvpb6ffinWafRqIrFx)
requirements document was given to us by a customer.

The example application we will build is called GTOnline: a lite social
networking site for networking socialites. It is a simple networking application
that provides features similar to those found on Facebook and LinkedIn.

## Analysis

Now that we familiarized ourselves with the customer requirements document, we
are ready to begin the analysis phase and convert these requirements into an
information flow diagram.

## Analysis: Information Flow Diagram

Let's take a look at an abstract information flow diagram. We use ellipses to
represent tasks, rectangles to represent documents, arrows to represent
information flow (*not* control flow), and a dashed line to represent the system
boundary. Here we see tasks `T1` through `T4` and documents `D1` through `D6`.

![An information flow diagram with
legend.](https://assets.omscs.io/notes/20220920173159.png)

 Let's look at `D1` and `D2` as examples. `D1` is an input document to task `T1`
 due to the directionality of the arrow connecting them. `T1` may write to or
 read from the database, as it connects to the database via a double-headed
 arrow. Document `D2` also connects to `T1` as an input and output document. As
 a result, `D2` may receive and send information to `T1`.

One task can interact with multiple documents, and one document can interact
with multiple tasks, but we never connect two documents, and we never connect
two tasks.

## Requirements 1

Let's look at the first screen in the requirements document: the login screen.
All users are uniquely identified by their email address and will log in to
GTOnline with that address and their password via this screen.

![The GTOnline login screen.](https://assets.omscs.io/notes/20221008133156.png)

A user enters an email and a password and clicks "Login". If they have supplied
a valid email/password combination, the system will log them in; otherwise, they
will be shown some error message and sent back to the login screen to try again.
Alternatively, if the user has not previously logged in, they must first
register by clicking the "Register" button.

The login task must then take these credentials and read from the database to
determine their validity, but it doesn't write any information supplied via this
screen into the database. Since the login document only supplies information to
the system, it is purely an input document.

## Requirements 2

Let's now look at the register screen. Here, the new user provides their first
name, last name, and email, a password and password confirmation, and clicks
"Register". If the user recalls that they had previously registered, they can
click "Cancel" and return to the login screen.

![The GTOnline register
screen.](https://assets.omscs.io/notes/20221008134915.png)

Upon clicking "Register", the system first determines if the supplied email
already belongs to a previously registered user. If the email is available and
the password and password confirmation are identical, the system will create a
new user with the supplied information.

The register document is an input document to the system, and the registration
task will write the information supplied via this screen into the database.

## Requirements 3

The system will send a new user to the edit profile screen immediately after
registering, which contains form fields for entering personal information,
interests, education, and professional information.

![The edit profile screen.](https://assets.omscs.io/notes/20221008144937.png)

In the personal information section, the user can enter their sex, birth date,
current city, and hometown. The system will write that information to the
database when they click "Save". Additionally, the user can type in one or more
personal interests and save those by clicking the "Add" button.

To add a school, the user selects a value from the school dropdown menu, enters
the year they graduated if applicable, and clicks "Save". To add a new job, the
user similarly selects a value from the employer dropdown menu, enters their job
title, and clicks "Save".

The edit profile document is both an input and an output document. Users can
enter information in the various sections of the screen, and the system will
save them appropriately. Notice that this document must read values from the
database, such as the list of schools and employers from which a user can
select.

## Requirements 4

In the view profile screen, we can see information about the user that they
entered previously in the edit profile screen, such as personal, educational,
and professional details.

![The view profile screen.](https://assets.omscs.io/notes/20221008150302.png)

This screen also contains several links that allow us to visit other screens.
For example, the view friends link will take us to a view friends screen which
shows a list of friends for this particular user. The view pending requests
screen will show us the list of friend requests that have not yet been accepted
or rejected. The edit profile link will send us back to the edit profile screen
we saw earlier. Of course, the logout link will log us out of the system.

The view profile screen is exclusively an output document; the user doesn't
provide any information to the system in this screen, only consumes it.
Additionally, this screen contains control information to navigate to other
screens in the application.

## Requirements 5

The search screen is both an input and output document: it receives a search
query from the user and displays the search results. Similarly, the friend
request screen is an input and output document: it shows information about the
friend to be requested and allows us to create new friend requests.

![The search screen and friend request
screen.](https://assets.omscs.io/notes/20221008151826.png)  

The pending friend request screen shows both inbound and outbound friend
requests. For each pending inbound request, the user can click "Accept" or
"Reject" to accept or deny the request, respectively. For each outbound request,
the user can click "Cancel" to cancel those requests. For all requests, the user
can see the name, hometown, and relationship information of the other user.

This document is an output document because it displays information from the
database, namely the list of friend requests. This document is also an input
document because it can cause changes in the database depending on whether we
click the various action buttons.

Finally, the friends list screen is an output document from the database that
displays information about all of the current user's friends.

![The pending friend request screen and the friends list
screen.](https://assets.omscs.io/notes/20221008151859.png)  

## IFD Chart

As we said previously, the output of the analysis phase of the database
application development methodology is an information flow diagram (IFD). Here
is the IFD that results from our analysis of the requirements of GTOnline.

![The information flow diagram for the GTOnline
application.](https://assets.omscs.io/notes/20220922083448.png)

The login form is an input to the login task. The login task reads from the
database to confirm that the combination of email address and password is
correct. If the credentials are valid, the task logs in the user.

The registration form is an input document, and the registration task creates a
new user from the supplied registration information.

The edit profile document is both an input and output document. As an input
document, it sends user-entered personal, educational, and professional
information to the database for persistence. As an output document, it reads the
school and employer reference data to populate the corresponding dropdown menus.

The view profile document is simply an output document populated with user
information from the database. Likewise, the friends list is an output document
that displays the list of friends for the current user.

The status/comments document is also an input and output document. It serves as
an output document when we view status updates can comments and as an input
document when we create our own status updates and add comments to other users'
status updates.

The friend search and search results document is both an input and output
document. When the search for friends task receives the search criteria from the
document, it reads qualified potential future friends from the database and
writes them back onto the document.

The friend request document is an input document. When we submit this document,
the request friend task writes the request to the database. The pending friends
list is both an input and an output document, displaying information about
inbound and outbound requests and providing actions to alter the status of those
requests.

Notice how the names of the input/output documents and tasks very closely
reflect the terms used in the requirements document. The IFD is just an initial,
high-level specification of the system. As we further analyze the tasks of the
system, we will expand the specificity with which we describe them. Despite
that, it is not necessary to refine this document: it just forms the basis for
the next phase in the methodology.

## Don't Go There

A software engineer or computer scientist might attempt to diagram the system as
follows. We have a login document and an associated login task. We have a single
task to maintain the database and several attached input and output documents.
Finally, we have a task to generate reports that sends data to a couple of
output documents.

![An incorrect information flow diagram for the GTOnline
application.](https://assets.omscs.io/notes/20220922084931.png)

Please don't take this approach, as it does not model the future system we are
building: this diagram models programs and code but not the flow of information.

## Specification

Now that we consumed the customer requirements and designed an information flow
diagram, our next task is specification. In this phase, we use the input and
output documents to design an extended entity-relationship (EER) diagram
representing a specification of the database. Next, we examine the tasks in the
IFD and provide a specification for each task relative to the input and output
documents and the database we have now designed. The output of this phase is the
EER diagram, data formats, constraints, and task decomposition.

## What Goes in/out of the Database?

How do we create a database specification from an information flow diagram? When
the database discipline was young, people referred to this process as the art of
database specification.

Over the years, Professor Mark has developed this database development
methodology, which attempts to take some of the art out of the process and add
some mechanical steps.

The methodology has two fundamental questions, and each question has two
observations:

1. What goes into the database?
   1. Everything in the database must come from somewhere. Data doesn't
      magically enter the database.
   2. Everything in an input document must go somewhere.
2. What comes out of the database?
   1. The system should use everything in the database for something; otherwise,
      why is it in the database?
   2. Everything on an output document must come from somewhere.

We can use these guiding observations to transition to the specification phase
of the database application development methodology.
