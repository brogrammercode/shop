const { Prisma } = require('@prisma/client');
console.log(Prisma.dmmf.datamodel.models.filter(m => m.fields.some(f => f.name === 'created_by')).map(m => m.name));
