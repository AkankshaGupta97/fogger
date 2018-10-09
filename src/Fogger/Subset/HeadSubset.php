<?php

namespace App\Fogger\Subset;

use App\Fogger\Recipe\Table;
use App\Fogger\Subset\Exception\SortByColumnRequired;
use Doctrine\DBAL\Query\QueryBuilder;

class HeadSubset extends AbstratctHeadOrTailSubset
{
    /**
     * @param QueryBuilder $queryBuilder
     * @param Table $table
     * @throws Exception\RequiredOptionMissingException
     * @throws SortByColumnRequired
     */
    public function subsetQuery(QueryBuilder $queryBuilder, Table $table)
    {
        $this->ensureOptionIsSet($table->getSubset()->getOptions(), 'length');
        $this->ensureValidPrimaryKey($table);

        $queryBuilder
            ->andWhere(sprintf('%s <= ?', $table->getSortBy()))
            ->setParameter(0, $this->findOffsetId($table, false));
    }

    public function getSubsetStrategyName(): string
    {
        return 'head';
    }
}
