# Task of topic shared-bug

> What we build, for whom, and how we will know it worked.

## In brief

The receipt shows amounts of money correctly.

## Task

The receipt shows 0.5 for 5 cents, must be 0.05. Customers read it as fifty cents.

## Success criteria

- `bash bin/receipt.sh 5` prints `Total: 0.05`.
