export function snakeToCamel(obj: any): any {
  if (typeof obj !== 'object' || obj === null) {
    return obj; // Return non-objects and null as-is
  }

  if (Array.isArray(obj)) {
    return obj.map(snakeToCamel); // Recursively convert array elements
  }

  const newObj: { [key: string]: any } = {};
  for (const key in obj) {
    if (Object.prototype.hasOwnProperty.call(obj, key)) {
      const camelKey = key.replace(/_([a-z])/g, (_, char) => char.toUpperCase());
      newObj[camelKey] = snakeToCamel(obj[key]); // Recursively convert values
    }
  }
  return newObj;
}
